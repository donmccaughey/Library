#import "InfoView.h"

@import LibraryKit;

#import "Notifications.h"


@implementation InfoView
{
    Book *_book;
    NSUInteger _count;
    NSInteger _index;
}


- (void)bookDidFinishReadingFile:(NSNotification *)notification;
{
    Book *book = notification.object;
    if (book == _book) [self updateLabels];
}


- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;
{
    Library *library = notification.object;
    _count = library.books.count;
    
    [self updateLabels];
}


- (void)updateLabels;
{
    if (_index == -1) {
        _sizeLabel.stringValue = @"";
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld books", _count];
    } else {
        NSString *byteCount = [NSByteCountFormatter stringFromByteCount:_book.fileSize
                                                             countStyle:NSByteCountFormatterCountStyleFile];
        NSUInteger pageCount = _book.pageCount;
        if (pageCount) {
            _sizeLabel.stringValue = [NSString stringWithFormat:@"%ld page %@ (%@)",
                                      pageCount, nameForFormat(_book.format), byteCount];
        } else {
            _sizeLabel.stringValue = [NSString stringWithFormat:@"%@ (%@)", nameForFormat(_book.format), byteCount];
        }
        
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld of %ld books", _index + 1, _count];
    }
}


- (void)userDidSelectBook:(NSNotification *)notification;
{
    _book = notification.userInfo[BookKey];
    
    NSNumber *index = notification.userInfo[IndexKey];
    _index = index.integerValue;
    
    [self updateLabels];
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _book = nil;
    _count = 0;
    _index = -1;
    
    return self;
}


- (void)viewDidMoveToWindow;
{
    [super viewDidMoveToWindow];
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidSelectBook:)
                                                     name:UserDidSelectBookNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bookDidFinishReadingFile:)
                                                     name:BookDidFinishReadingFileNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(libraryDidFinishScanningFolders:)
                                                     name:LibraryDidFinishScanningFoldersNotification
                                                   object:nil];
    }
}


- (void)viewWillMoveToWindow:(NSWindow *)newWindow;
{
    if ( ! newWindow) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [super viewWillMoveToWindow:newWindow];
}


@end
