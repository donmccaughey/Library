#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface ElapsedTime : NSObject

@property (readonly) NSTimeInterval seconds;

+ (instancetype)elapsedTimeWithSeconds:(NSTimeInterval)seconds;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSeconds:(NSTimeInterval)seconds;

@end


NS_ASSUME_NONNULL_END
