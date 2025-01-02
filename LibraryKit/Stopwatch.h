#import <Foundation/Foundation.h>


@class ElapsedTime;


NS_ASSUME_NONNULL_BEGIN


@interface Stopwatch : NSObject

+ (instancetype)start;

- (ElapsedTime *)stop;

@end


NS_ASSUME_NONNULL_END
