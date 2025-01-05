#import <Foundation/Foundation.h>

#import "BiMap.h"


NS_ASSUME_NONNULL_BEGIN


@interface XML : NSObject<NSXMLParserDelegate>
{
@protected
    NSMutableArray<NSString *> *_characters;
    NSError *_error;
    BiMap<NSString *, NSString *> *_prefixToNamespace;
}

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithShouldFindCharacters:(BOOL)shouldFindCharacters;

- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;

@end


NS_ASSUME_NONNULL_END
