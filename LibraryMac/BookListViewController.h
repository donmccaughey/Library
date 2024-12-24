@import Cocoa;


@class LibraryDataSource;


NS_ASSUME_NONNULL_BEGIN


@interface BookListViewController : NSViewController<NSTableViewDelegate>

@property (weak) IBOutlet LibraryDataSource *libraryDataSource;
@property (weak) IBOutlet NSTableView *tableView;

- (void)didFinishScanningForBooks:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
