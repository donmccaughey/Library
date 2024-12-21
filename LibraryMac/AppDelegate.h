@import Cocoa;


@class Book;
@class InfoView;
@class Library;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (strong) Library *library;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSWindow *window;

- (void)bookWasSelected;

@end
