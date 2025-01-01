#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface BiMap<__covariant FirstType, __covariant SecondType> : NSObject

- (nullable FirstType)firstForSecond:(SecondType)second;

- (nullable SecondType)secondForFirst:(FirstType)first;

- (void)setFirst:(FirstType)first forSecond:(SecondType)second;

- (void)removeFirst:(FirstType)first;

- (void)removeSecond:(SecondType)second;

@end


NS_ASSUME_NONNULL_END
