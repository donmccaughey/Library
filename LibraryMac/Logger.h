@import Foundation;


NS_ASSUME_NONNULL_BEGIN


@interface Logger : NSObject

- (void)willStartScanningForBooks:(NSNotification *)notification;

- (void)didFinishScanningForBooks:(NSNotification *)notification;

- (void)didSelectBook:(NSNotification *)notification;

- (void)willStartOpeningBook:(NSNotification *)notification;

- (void)didFinishOpeningBook:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
