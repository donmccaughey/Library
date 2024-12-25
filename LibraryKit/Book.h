#import <LibraryKit/BookType.h>


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const BookWillStartReadingFileNotification;
extern NSNotificationName const BookDidFinishReadingFileNotification;


@interface Book : NSObject

@property (readonly) NSNumber *fileSize;
@property (readonly) NSUInteger pageCount;
@property (readonly) NSString *path;
@property (readonly) NSString *title;
@property (readonly) enum BookType type;
@property (readonly) BOOL wasRead;

- (nullable instancetype)initWithPath:(NSString *)path
                          andFileSize:(NSNumber *)fileSize;

- (void)startReadingFile;

@end


NS_ASSUME_NONNULL_END
