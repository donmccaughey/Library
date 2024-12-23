#import "Logger.h"

@import LibraryKit;

#import "Notifications.h"


double const NANOS_PER_SEC = 1e9;
double const NANOS_PER_MILLI = 1e6;
double const NANOS_PER_MICRO = 1e3;


struct timespec
calculateInterval(struct timespec start, struct timespec end);

struct timespec
calculateIntervalToNow(struct timespec start);

NSString *
formatInterval(struct timespec elapsedTime);


@implementation Logger
{
    struct timespec _startOpeningBookTime;
    struct timespec _startScanningForBooksTime;
}


- (void)willStartScanningForBooks:(NSNotification *)notification;
{
    NSLog(@"Will start scanning for books.");
    clock_gettime(CLOCK_UPTIME_RAW, &_startScanningForBooksTime);
}


- (void)didFinishScanningForBooks:(NSNotification *)notification;
{
    struct timespec scanTime = calculateIntervalToNow(_startScanningForBooksTime);
    NSLog(@"Did finish scanning for books in %@", formatInterval(scanTime));
}


- (void)didSelectBook:(NSNotification *)notification;
{
    id value = notification.userInfo[BookKey];
    if ([NSNull null] == value) {
        NSLog(@"Did deselect book");
    } else {
        Book *book = value;
        NSNumber *index = notification.userInfo[IndexKey];
        NSUInteger i = 1 + index.unsignedLongValue;
        NSNumber *count = notification.userInfo[CountKey];
        NSLog(@"Did select %@ book %lu of %@: \"%@\"", book.typeName, i, count, book);
    }
}


- (void)willStartOpeningBook:(NSNotification *)notification;
{
    Book *book = notification.object;
    NSLog(@"Will start opening book '%@'", book);
    clock_gettime(CLOCK_UPTIME_RAW, &_startOpeningBookTime);
}


- (void)didFinishOpeningBook:(NSNotification *)notification;
{
    struct timespec openTime = calculateIntervalToNow(_startOpeningBookTime);
    Book *book = notification.object;
    NSLog(@"Did finish opening book '%@' in %@", book, formatInterval(openTime));
}


- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willStartScanningForBooks:)
                                                 name:WillStartScanningForBooksNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishScanningForBooks:)
                                                 name:DidFinishScanningForBooksNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectBook:)
                                                 name:DidSelectBookNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willStartOpeningBook:)
                                                 name:WillStartOpeningBookNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishOpeningBook:)
                                                 name:DidFinishOpeningBookNotification
                                               object:nil];
    
    return self;
}


@end


struct timespec
calculateInterval(struct timespec start, struct timespec end)
{
    struct timespec diff;
    if (end.tv_nsec < start.tv_nsec) {
        diff.tv_sec = end.tv_sec - start.tv_sec - 1;
        diff.tv_nsec = 1000000000 + end.tv_nsec - start.tv_nsec;
    } else {
        diff.tv_sec = end.tv_sec - start.tv_sec;
        diff.tv_nsec = end.tv_nsec - start.tv_nsec;
    }
    return diff;
}


struct timespec
calculateIntervalToNow(struct timespec start)
{
    struct timespec timeNow;
    clock_gettime(CLOCK_UPTIME_RAW, &timeNow);
    return calculateInterval(start, timeNow);
}


NSString *
formatInterval(struct timespec elapsedTime)
{
   if (elapsedTime.tv_sec > 0) {
       double seconds = elapsedTime.tv_sec + elapsedTime.tv_nsec / NANOS_PER_SEC;
       return [NSString stringWithFormat:@"%.1f s", seconds];
   } else if (elapsedTime.tv_nsec >= 1000000) {
       double milliseconds = elapsedTime.tv_nsec / NANOS_PER_MILLI;
       return [NSString stringWithFormat:@"%.1f ms", milliseconds];
   } else {
       double microseconds = elapsedTime.tv_nsec / NANOS_PER_MICRO;
       return [NSString stringWithFormat:@"%.1f µs", microseconds];
   }
}
