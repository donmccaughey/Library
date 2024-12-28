#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@protocol File

@property (readonly) NSUInteger pageCount;
@property (nullable, readonly, copy) NSString *title;

@end


NS_ASSUME_NONNULL_END
