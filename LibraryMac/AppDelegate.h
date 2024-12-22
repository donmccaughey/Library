@import Cocoa;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSWindow *window;

- (void)didFinishScanningForBooks:(NSNotification *)notification;

- (void)postDidSelectBookNotification;

@end
