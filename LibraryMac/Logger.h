@import Foundation;


NS_ASSUME_NONNULL_BEGIN


@interface Logger : NSObject

- (void)libraryWillStartScanningFolders:(NSNotification *)notification;

- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;

- (void)userDidSelectBook:(NSNotification *)notification;

- (void)bookWillStartReadingFile:(NSNotification *)notification;

- (void)bookDidFinishReadingFile:(NSNotification *)notification;

@end


NS_ASSUME_NONNULL_END
