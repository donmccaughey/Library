@import Cocoa;


@class Book;


NS_ASSUME_NONNULL_BEGIN


@interface InfoView : NSView

@property (strong) IBOutlet NSTextField *countLabel;
@property (strong) IBOutlet NSTextField *sizeLabel;

- (void)didSelectBook:(NSNotification *)notification;

- (void)didFinishOpeningBook:(NSNotification *)notification;

- (void)updateLabels;

@end


NS_ASSUME_NONNULL_END
