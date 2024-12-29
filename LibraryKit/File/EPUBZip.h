#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface EPUBZip : NSObject

@property (readonly) NSString *path;
@property (readonly) void *reader;

- (nullable instancetype)initWithPath:(NSString *)path;

- (nullable NSData *)dataForEntryWithPath:(NSString *)entryPath;

- (NSArray<NSString *> *)entryPathsMatchingPredicate:(NSPredicate *)predicate;

- (NSArray<NSString *> *)entryPathsWithExtension:(NSString *)extension;

@end


NS_ASSUME_NONNULL_END
