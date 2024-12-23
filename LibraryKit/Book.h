#import <Foundation/Foundation.h>


@class FileMatcher;


enum BookType : NSUInteger {
    BookTypeUnknown,
    BookTypeEPUB,
    BookTypePDF,
};


NS_ASSUME_NONNULL_BEGIN


@interface Book : NSObject

@property (readonly) NSNumber *fileSize;
@property (readonly) NSUInteger pageCount;
@property (readonly) NSString *path;
@property (readonly) NSString *title;
@property (readonly) enum BookType type;
@property (readonly) NSString *typeName;

+ (NSArray<FileMatcher *> *)fileMatchers;

+ (BOOL)isBookFile:(NSString *)path;

- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;

@end


NS_ASSUME_NONNULL_END
