#import <Cocoa/Cocoa.h>


@class Library;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (readonly) NSWorkspaceAuthorization *authorization;
@property (strong) Library *library;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSWindow *window;

- (void)loadLibrary;

@end
