#import "Logger.h"

@import LibraryKit;

#import "Notifications.h"


@implementation Logger


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bookWillStartScanningFile:)
                                                 name:BookWillStartScanningFileNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bookDidFinishScanningFile:)
                                                 name:BookDidFinishScanningFileNotification
                                               object:nil];
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
    
    return self;
}


- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)bookWillStartScanningFile:(NSNotification *)notification;
{
    // nothing to do
}


- (void)bookDidFinishScanningFile:(NSNotification *)notification;
{
    Book *book = notification.object;
    NSLog(@"Book '%@' did finish scanning %@ file in %@",
          book, nameForFormat(book.format), book.scanTime);
}


- (void)libraryWillStartScanningFolders:(NSNotification *)notification;
{
    // nothing to do
}


- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;
{
    Library *library = notification.object;
    NSLog(@"Library did finish scanning folders in %@", library.scanTime);
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


@end
