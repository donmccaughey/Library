#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface OPFIdentifier : NSObject

@property (nullable, readonly) NSString *ID;
@property NSString *identifier;
@property (nullable, readonly) NSString *scheme;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithID:(nullable NSString *)ID
                 andScheme:(nullable NSString *)scheme;

@end


NS_ASSUME_NONNULL_END
