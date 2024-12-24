@import Cocoa;


@class LibraryDataSource;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate>

@property IBOutlet LibraryDataSource *libraryDataSource;
@property (weak) IBOutlet NSTableView *tableView;
@property IBOutlet NSWindow *window;

- (void)didFinishScanningForBooks:(NSNotification *)notification;

- (void)updateSelectedBook;

@end
