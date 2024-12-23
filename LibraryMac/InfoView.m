#import "InfoView.h"

@import LibraryKit;

#import "Notifications.h"


@implementation InfoView


- (void)didSelectBook:(NSNotification *)notification;
{
    Book *book = notification.userInfo[BookKey];
    NSNumber *count = notification.userInfo[CountKey];
    NSNumber *index = notification.userInfo[IndexKey];
    if (index.integerValue == -1) {
        _sizeLabel.stringValue = @"";
        _countLabel.stringValue = [NSString stringWithFormat:@"%@ books", count];
    } else {
        NSString *byteCount = [NSByteCountFormatter stringFromByteCount:book.fileSize.longLongValue
                                                             countStyle:NSByteCountFormatterCountStyleFile];
        NSUInteger pageCount = book.pageCount;
        if (pageCount) {
            NSString *plural = 1 == pageCount ? @"" : @"s";
            _sizeLabel.stringValue = [NSString stringWithFormat:@"%@: %ld page%@ (%@)", book.typeName, pageCount, plural, byteCount];
        } else {
            _sizeLabel.stringValue = [NSString stringWithFormat:@"%@: (%@)", book.typeName, byteCount];
        }
        
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld of %@ books", index.integerValue + 1, count];
    }
}


- (void)viewDidMoveToWindow;
{
    [super viewDidMoveToWindow];
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSelectBook:)
                                                     name:DidSelectBookNotification
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
