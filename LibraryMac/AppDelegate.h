@import Cocoa;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSWindow *window;

- (void)libraryDidFinishScanningForBooks:(NSNotification *)notification;

- (void)postBookSelectionDidChangeNotification;

@end
