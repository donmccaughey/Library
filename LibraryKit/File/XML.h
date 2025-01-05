#import <Foundation/Foundation.h>

#import "BiMap.h"


NS_ASSUME_NONNULL_BEGIN


@interface XML : NSObject<NSXMLParserDelegate>
{
@protected
    NSMutableArray<NSString *> *_characters;
    NSError *_error;
    NSXMLParser *_parser;
    BiMap<NSString *, NSString *> *_prefixToNamespace;
}

@property (readonly) NSError *error;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithData:(NSData *)xml
     andShouldFindCharacters:(BOOL)shouldFindCharacters;

- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;

@end


NS_ASSUME_NONNULL_END
