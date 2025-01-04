#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


extern NSErrorDomain ZipErrorDomain;


@interface Zip : NSObject

@property (readonly) NSString *path;

- (nullable instancetype)initWithPath:(NSString *)path
                                error:(NSError **)error;

- (nullable NSData *)dataForEntryWithPath:(NSString *)entryPath
                                    error:(NSError **)error;

- (nullable NSString *)pathOfFirstEntryWithError:(NSError **)error;

@end


NS_ASSUME_NONNULL_END
