@import Cocoa;
@import LibraryKit;

#import "AppDelegate.h"


void
loadLibrary(NSArray<NSString *> *dirs)
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        Library *library = [[Library alloc] initWithDirs:dirs];
        [library scanDirsForBooks];
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *appDelegate = (AppDelegate *)NSApp.delegate;
            appDelegate.library = library;
        });
    });
}
