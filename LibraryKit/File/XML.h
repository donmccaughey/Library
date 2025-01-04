#import <Foundation/Foundation.h>

#import "BiMap.h"


NS_ASSUME_NONNULL_BEGIN


@interface XML : NSObject<NSXMLParserDelegate>
{
@protected
    NSError *_parseError;
    BiMap<NSString *, NSString *> *_prefixToNamespace;
}

- (instancetype)init;

- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;

@end


NS_ASSUME_NONNULL_END
