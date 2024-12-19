#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface FileMatcher : NSObject

- (BOOL)pathMatches:(NSString *)path;

@end


NS_ASSUME_NONNULL_END
