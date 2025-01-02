#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


extern NSErrorDomain ZipErrorDomain;


@interface Zip : NSObject

@property (readonly) NSString *path;
@property (readonly) void *reader;

- (nullable instancetype)initWithPath:(NSString *)path
                                error:(NSError **)error;

- (nullable NSData *)dataForEntryWithPath:(NSString *)entryPath
                                    error:(NSError **)error;

- (NSArray<NSString *> *)entryPathsMatchingPredicate:(NSPredicate *)predicate;

- (NSArray<NSString *> *)entryPathsWithExtension:(NSString *)extension;

@end


NS_ASSUME_NONNULL_END
