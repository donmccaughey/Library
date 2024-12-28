#import <LibraryKit/File.h>


NS_ASSUME_NONNULL_BEGIN


@interface EPUB : NSObject<File>

@property (readonly) NSUInteger pageCount;
@property (nullable, readonly, copy) NSString *title;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPath:(NSString *)path;

@end


NS_ASSUME_NONNULL_END
