#import "AppDelegate.h"

@import LibraryKit;

#import "Logger.h"


@implementation AppDelegate
{
    NSArray<NSString *> *_dirs;
    Logger *_logger;
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _dirs = @[];
    _logger = [Logger new];
    
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app;
{
    return YES;
}


- (void)applicationWillFinishLaunching:(NSNotification *)notification;
{
    _dirs = @[
        @"/Users/donmcc/Documents",
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library",
    ];
    [_library startScanningForBooksInDirs:_dirs];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
