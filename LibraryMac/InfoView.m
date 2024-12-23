#import "InfoView.h"

@import LibraryKit;

#import "Notifications.h"


@implementation InfoView
{
    Book *_book;
    NSUInteger _count;
    NSInteger _index;
}


- (void)didSelectBook:(NSNotification *)notification;
{
    _book = notification.userInfo[BookKey];
    
    NSNumber *count = notification.userInfo[CountKey];
    _count = count.unsignedIntegerValue;
    
    NSNumber *index = notification.userInfo[IndexKey];
    _index = index.integerValue;
    
    [self updateLabels];
}


- (void)didFinishOpeningBook:(NSNotification *)notification;
{
    Book *book = notification.object;
    if (book == _book) [self updateLabels];
}


- (void)updateLabels;
{
    if (_index == -1) {
        _sizeLabel.stringValue = @"";
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld books", _count];
    } else {
        NSString *byteCount = [NSByteCountFormatter stringFromByteCount:_book.fileSize.longLongValue
                                                             countStyle:NSByteCountFormatterCountStyleFile];
        NSUInteger pageCount = _book.pageCount;
        if (pageCount) {
            _sizeLabel.stringValue = [NSString stringWithFormat:@"%ld page %@ (%@)", pageCount, _book.typeName, byteCount];
        } else {
            _sizeLabel.stringValue = [NSString stringWithFormat:@"%@ (%@)", _book.typeName, byteCount];
        }
        
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld of %ld books", _index + 1, _count];
    }
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
                                                 selector:@selector(didSelectBook:)
                                                     name:DidSelectBookNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFinishOpeningBook:)
                                                     name:DidFinishOpeningBookNotification
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
