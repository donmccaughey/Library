@import Foundation;


NS_ASSUME_NONNULL_BEGIN


@interface Logger : NSObject

- (void)libraryWillStartScanningFolders:(NSNotification *)notification;

- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;

- (void)userDidSelectBook:(NSNotification *)notification;

- (void)bookWillStartOpening:(NSNotification *)notification;

- (void)bookDidFinishOpening:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
