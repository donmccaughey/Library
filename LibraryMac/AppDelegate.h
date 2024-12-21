@import Cocoa;


@class Book;
@class InfoView;
@class Library;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (strong, readonly) Library *library;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSWindow *window;

- (void)libraryDidFinishScanningForBooks:(NSNotification *)notification;

- (void)postBookSelectionDidChangeNotification;

@end
