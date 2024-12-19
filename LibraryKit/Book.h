#import <Foundation/Foundation.h>


@class FileMatcher;


NS_ASSUME_NONNULL_BEGIN


@interface Book : NSObject

@property (readonly) NSString *path;

+ (NSArray<FileMatcher *> *)fileMatchers;

- (instancetype)initWithPath:(NSString *)path;

@end


NS_ASSUME_NONNULL_END
