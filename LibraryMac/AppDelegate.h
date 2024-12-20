@import Cocoa;


@class InfoView;
@class Library;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (readonly) NSWorkspaceAuthorization *authorization;
@property (weak) IBOutlet InfoView *infoView;
@property (strong) Library *library;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSWindow *window;

@end
