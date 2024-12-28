#import <LibraryKit/File.h>


NS_ASSUME_NONNULL_BEGIN


@interface PDF : NSObject<File>

@property (readonly) NSUInteger pageCount;
@property (nullable, readonly) NSString *title;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPath:(NSString *)path;

@end


NS_ASSUME_NONNULL_END
