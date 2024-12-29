#import <LibraryKit/Format.h>


@protocol File;


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const BookWillStartReadingFileNotification;
extern NSNotificationName const BookDidFinishReadingFileNotification;


@interface Book : NSObject

@property (readonly) Class<File> fileClass;
@property (readonly) NSNumber *fileSize;
@property (readonly) enum Format format;
@property (readonly) NSUInteger pageCount;
@property (readonly) NSString *path;
@property (readonly) NSString *title;
@property (readonly) BOOL wasRead;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPath:(NSString *)path
                          andFileSize:(NSNumber *)fileSize;

- (void)startReadingFile;

@end


NS_ASSUME_NONNULL_END
