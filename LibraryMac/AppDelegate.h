@import Cocoa;


@class Library;


@interface AppDelegate : NSObject<NSApplicationDelegate>

@property (weak) IBOutlet Library *library;
@property IBOutlet NSWindow *window;

@end
