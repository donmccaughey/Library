#import <LibraryKit/Format.h>


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const BookWillStartReadingFileNotification;
extern NSNotificationName const BookDidFinishReadingFileNotification;


@interface Book : NSObject

@property (nullable, readonly) NSError *error;
@property (readonly) NSDate *fileCreationDate;
@property (readonly) NSDate *fileModificationDate;
@property (readonly) unsigned long long fileSize;
@property (readonly) enum Format format;
@property (readonly) NSUInteger pageCount;
@property (readonly) NSString *path;
@property (readonly) NSString *title;
@property (readonly) BOOL wasRead;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPath:(NSString *)path
                    andFileAttributes:(NSDictionary<NSFileAttributeKey, id> *)fileAttributes;

- (void)startReadingFile;

@end


NS_ASSUME_NONNULL_END
