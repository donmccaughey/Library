#import "AppDelegate.h"

@import LibraryKit;

#import "InfoView.h"
#import "LibraryDataSource.h"
#import "Logger.h"
#import "Notifications.h"


@implementation AppDelegate
{
    Logger *_logger;
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _logger = [Logger new];
    
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    // nothing to do here
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app;
{
    return YES;
}


- (void)applicationWillFinishLaunching:(NSNotification *)notification;
{
    NSArray<NSString *> *dirs = @[
        @"/Users/donmcc/Documents",
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library",
    ];
    Library *library = [[Library alloc] initWithDirs:dirs];
    _libraryDataSource.library = library;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
