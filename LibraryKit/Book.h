#import <LibraryKit/BookType.h>


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const BookWillStartOpeningNotification;
extern NSNotificationName const BookDidFinishOpeningNotification;


@interface Book : NSObject

@property (readonly) NSNumber *fileSize;
@property (readonly) BOOL isOpen;
@property (readonly) NSUInteger pageCount;
@property (readonly) NSString *path;
@property (readonly) NSString *title;
@property (readonly) enum BookType type;

- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;

- (void)startOpening;

- (void)close;

@end


NS_ASSUME_NONNULL_END
