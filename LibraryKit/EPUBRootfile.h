#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface EPUBRootfile : NSObject

@property (readonly) NSString *fullPath;
@property (readonly) BOOL isPackage;
@property (readonly) NSString *mediaType;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMediaType:(NSString *)mediaType
                      andFullPath:(NSString *)fullPath;

@end


NS_ASSUME_NONNULL_END
