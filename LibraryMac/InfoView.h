@import Cocoa;


@class Book;


NS_ASSUME_NONNULL_BEGIN


@interface InfoView : NSView

@property (weak) IBOutlet NSTextField *countLabel;
@property (weak) IBOutlet NSTextField *sizeLabel;

- (void)bookDidFinishOpening:(NSNotification *)notification;

- (void)didSelectBook:(NSNotification *)notification;

- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;

- (void)updateLabels;

@end


NS_ASSUME_NONNULL_END
