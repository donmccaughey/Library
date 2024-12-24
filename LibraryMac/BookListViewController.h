@import Cocoa;


@class Library;


NS_ASSUME_NONNULL_BEGIN


@interface BookListViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet Library *library;
@property (weak) IBOutlet NSTableView *tableView;

- (void)didFinishScanningForBooks:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
