#import "Logger.h"

@import LibraryKit;

#import "Notifications.h"


@implementation Logger
{
    struct timespec _startScanningForBooksTime;
}


- (void)libraryWillStartScanningFolders:(NSNotification *)notification;
{
    NSLog(@"Library will start scanning folders.");
    clock_gettime(CLOCK_UPTIME_RAW, &_startScanningForBooksTime);
}


- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;
{
    struct timespec scanTime = calculateDurationFrom(_startScanningForBooksTime);
    NSLog(@"Library did finish scanning folders in %@", formatDuration(scanTime));
}


- (void)userDidSelectBook:(NSNotification *)notification;
{
    id value = notification.userInfo[BookKey];
    if ([NSNull null] == value) {
        NSLog(@"Did deselect book");
    } else {
        Book *book = value;
        NSNumber *index = notification.userInfo[IndexKey];
        NSUInteger i = 1 + index.unsignedLongValue;
        NSLog(@"Did select %@ book %lu: '%@'", nameForFormat(book.format), i, book);
    }
}


- (void)bookWillStartReadingFile:(NSNotification *)notification;
{
    // nothing to do
}


- (void)bookDidFinishReadingFile:(NSNotification *)notification;
{
    Book *book = notification.object;
    NSLog(@"Book '%@' did finish reading %@ file in %@",
          book, nameForFormat(book.format), formatTimeInterval(book.readTime));
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
                                             selector:@selector(libraryWillStartScanningFolders:)
                                                 name:LibraryWillStartScanningFoldersNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(libraryDidFinishScanningFolders:)
                                                 name:LibraryDidFinishScanningFoldersNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectBook:)
                                                 name:UserDidSelectBookNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bookWillStartReadingFile:)
                                                 name:BookWillStartReadingFileNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bookDidFinishReadingFile:)
                                                 name:BookDidFinishReadingFileNotification
                                               object:nil];
    
    return self;
}


@end
