@import Cocoa;


@class Library;


NS_ASSUME_NONNULL_BEGIN


@interface BookListViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet Library *library;
@property (weak) IBOutlet NSTableView *tableView;

- (void)bookDidFinishScanningFile:(NSNotification *)notification;

- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
