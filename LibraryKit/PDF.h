#import <LibraryKit/File.h>


NS_ASSUME_NONNULL_BEGIN


@interface PDF : NSObject<File>

@property (readonly) NSUInteger pageCount;
@property (readonly) NSString *title;

- (instancetype)initWithPath:(NSString *)path;

@end


NS_ASSUME_NONNULL_END
