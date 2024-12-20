@import Cocoa;


NS_ASSUME_NONNULL_BEGIN


@interface InfoView : NSView

@property (strong) IBOutlet NSTextField *countLabel;

- (void)updateWithBooksCount:(NSInteger)count
            andSelectedIndex:(NSInteger)selectedIndex;

@end


NS_ASSUME_NONNULL_END
