#import <Foundation/Foundation.h>


@class FileMatcher;


NS_ASSUME_NONNULL_BEGIN


@interface Book : NSObject

@property (readonly) NSNumber *fileSize;
@property (readonly) NSString *path;
@property (readonly) NSString *title;

+ (NSArray<FileMatcher *> *)fileMatchers;

- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;

@end


NS_ASSUME_NONNULL_END
