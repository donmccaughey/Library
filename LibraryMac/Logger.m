#import "Logger.h"

@import LibraryKit;


double const NANOS_PER_SEC = 1e9;
double const NANOS_PER_MILLI = 1e6;
double const NANOS_PER_MICRO = 1e3;


NSString *
formatElapsedTime(struct timespec elapsedTime);

struct timespec
interval(struct timespec start, struct timespec end);


@implementation Logger
{
    struct timespec _startScanningForBooksTime;
}


- (void)libraryDidStartScanningForBooks:(NSNotification *)notification;
{
    clock_gettime(CLOCK_UPTIME_RAW, &_startScanningForBooksTime);
    NSLog(@"Did start scanning for books.");
}


- (void)libraryDidFinishScanningForBooks:(NSNotification *)notification;
{
    struct timespec timeNow;
    clock_gettime(CLOCK_UPTIME_RAW, &timeNow);
    struct timespec scanTime = interval(_startScanningForBooksTime, timeNow);

    NSLog(@"Did finish scanning for books in %@", formatElapsedTime(scanTime));
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
                                             selector:@selector(libraryDidStartScanningForBooks:)
                                                 name:LibraryDidStartScanningForBooksNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(libraryDidFinishScanningForBooks:)
                                                 name:LibraryDidFinishScanningForBooksNotification
                                               object:nil];
    
    return self;
}


@end


NSString *
formatElapsedTime(struct timespec elapsedTime)
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


struct timespec
interval(struct timespec start, struct timespec end)
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
