#import "InfoView.h"

@import LibraryKit;

#import "Notifications.h"


@implementation InfoView


- (void)onBookSelected:(NSNotification *)notification;
{
    Book *book = notification.userInfo[BookSelectedBookKey];
    NSNumber *count = notification.userInfo[BookSelectedCountKey];
    NSNumber *index = notification.userInfo[BookSelectedIndexKey];
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
                                                 selector:@selector(onBookSelected:)
                                                     name:BookSelectedNotification
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
