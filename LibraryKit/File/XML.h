#import <Foundation/Foundation.h>

#import "XMLNamespaceMap.h"


NS_ASSUME_NONNULL_BEGIN


@interface XML : NSObject<NSXMLParserDelegate>
{
@protected
    NSMutableArray<NSString *> *_characters;
    NSError *_error;
    XMLNamespaceMap *_namespaceMap;
    NSXMLParser *_parser;
}

@property (readonly) NSError *error;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithData:(NSData *)xml
        shouldFindCharacters:(BOOL)shouldFindCharacters;

- (BOOL)is:(NSString *)namespaceURI1 :(NSString *)name1
   equalTo:(NSString *)namespaceURI2 :(NSString *)name2;

- (NSString *)trimmedCharacters;

- (NSString *)valueForQualifiedName:(NSString *)namespaceURI :(NSString *)name
                     fromAttributes:(NSDictionary<NSString *, NSString *> *)attributes;

@end


NS_ASSUME_NONNULL_END
