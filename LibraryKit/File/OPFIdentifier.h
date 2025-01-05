#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface OPFIdentifier : NSObject

@property (readonly) NSString *identifier;
@property (readonly) NSString *scheme;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithScheme:(NSString *)scheme
                 andIdentifier:(NSString *)identifier;

@end


NS_ASSUME_NONNULL_END
