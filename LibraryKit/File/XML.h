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
        shouldFindCharacters:(BOOL)shouldFindCharacters;

- (BOOL)is:(NSString *)namespace1 :(NSString *)name1
   equalTo:(NSString *)namespace2 :(NSString *)name2;

- (NSString *)q:(NSString *)namespace :(NSString *)name;

- (NSString *)trimmedCharacters;

@end


NS_ASSUME_NONNULL_END
