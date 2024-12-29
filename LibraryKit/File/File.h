#import <Foundation/Foundation.h>

#import <LibraryKit/Format.h>


NS_ASSUME_NONNULL_BEGIN


@protocol File

@property (readonly) enum Format format;
@property (readonly) NSUInteger pageCount;
@property (nullable, readonly) NSString *title;

+ (instancetype)alloc;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPath:(NSString *)path;

@end


NS_ASSUME_NONNULL_END
