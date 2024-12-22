#import "InfoView.h"

@import LibraryKit;

#import "Notifications.h"


@implementation InfoView


- (void)bookSelectionDidChange:(NSNotification *)notification;
{
    Book *book = notification.userInfo[BookKey];
    NSNumber *count = notification.userInfo[CountKey];
    NSNumber *index = notification.userInfo[IndexKey];
    if (index.integerValue == -1) {
        _countLabel.stringValue = [NSString stringWithFormat:@"%@ books", count];
        _sizeLabel.stringValue = @"";
    } else {
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld of %@ books", index.integerValue + 1, count];
        _sizeLabel.stringValue = [NSByteCountFormatter stringFromByteCount:book.fileSize.longLongValue
                                                                countStyle:NSByteCountFormatterCountStyleFile];
    }
}


- (void)viewDidMoveToWindow;
{
    [super viewDidMoveToWindow];
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bookSelectionDidChange:)
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
