@import Cocoa;


@class LibraryDataSource;


@interface AppDelegate : NSObject<NSApplicationDelegate>

@property (weak) IBOutlet LibraryDataSource *libraryDataSource;
@property IBOutlet NSWindow *window;

@end
