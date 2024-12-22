@import Foundation;


NS_ASSUME_NONNULL_BEGIN


@interface Logger : NSObject

- (void)libraryWillStartScanningForBooks:(NSNotification *)notification;

- (void)libraryDidFinishScanningForBooks:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
