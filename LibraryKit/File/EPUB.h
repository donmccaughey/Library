#import <LibraryKit/File.h>


NS_ASSUME_NONNULL_BEGIN


@interface EPUB : NSObject<File>

@property (readonly) NSUInteger pageCount;
@property (nullable, readonly) NSString *title;

@end


NS_ASSUME_NONNULL_END
