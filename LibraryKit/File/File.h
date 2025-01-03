#import <Foundation/Foundation.h>

#import <LibraryKit/Format.h>


NS_ASSUME_NONNULL_BEGIN


@protocol File

@property (readonly) NSUInteger pageCount;
@property (nullable, readonly) NSString *title;

+ (instancetype)alloc;

+ (Format)format;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithPath:(NSString *)path
                                error:(NSError **)error;

@end


NS_ASSUME_NONNULL_END
