@import Cocoa;


@class Book;


NS_ASSUME_NONNULL_BEGIN


@interface InfoView : NSView

@property (strong) IBOutlet NSTextField *countLabel;
@property (strong) IBOutlet NSTextField *sizeLabel;

- (void)onBookSelected:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
