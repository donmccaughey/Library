#import "AppDelegate.h"

@import LibraryKit;

#import "Logger.h"


@implementation AppDelegate
{
    NSArray<NSString *> *_folders;
    Logger *_logger;
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _folders = @[];
    _logger = [Logger new];
    
    return self;
}


- (void)applicationWillFinishLaunching:(NSNotification *)notification;
{
    _folders = @[
        @"/Users/donmcc/Documents",
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library",
    ];
    [_library startScanningFolders:_folders];
}


@end
