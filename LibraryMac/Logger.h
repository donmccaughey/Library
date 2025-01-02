@import Foundation;


NS_ASSUME_NONNULL_BEGIN


@interface Logger : NSObject

- (void)bookWillStartScanningFile:(NSNotification *)notification;

- (void)bookDidFinishScanningFile:(NSNotification *)notification;

- (void)libraryWillStartScanningFolders:(NSNotification *)notification;

- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;

- (void)userDidSelectBook:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
