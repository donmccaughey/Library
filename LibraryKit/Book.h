#import <LibraryKit/Format.h>


NS_ASSUME_NONNULL_BEGIN


@class ElapsedTime;


extern NSNotificationName const BookWillStartScanningFileNotification;
extern NSNotificationName const BookDidFinishScanningFileNotification;


@interface Book : NSObject

@property (nullable, readonly) NSError *error;
@property (readonly) NSDate *fileCreationDate;
@property (readonly) NSDate *fileModificationDate;
@property (readonly) unsigned long long fileSize;
@property (readonly) Format format;
@property (readonly) NSUInteger pageCount;
@property (readonly) NSString *path;
@property (readonly) BOOL scanFailed;
@property (nullable, readonly) ElapsedTime *scanTime;
@property (readonly) NSString *title;
@property (readonly) BOOL wasScanned;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPath:(NSString *)path
                    andFileAttributes:(NSDictionary<NSFileAttributeKey, id> *)fileAttributes;

- (void)startScanningFile;

@end


NS_ASSUME_NONNULL_END
