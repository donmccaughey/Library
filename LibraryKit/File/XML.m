#import "XML.h"

#import "BiMap.h"


@implementation XML


- (instancetype)initWithShouldFindCharacters:(BOOL)shouldFindCharacters;
{
    self = [super init];
    if ( ! self) return nil;
    
    _prefixToNamespace = [BiMap new];
    
    if (shouldFindCharacters) _characters = [NSMutableArray new];
    
    return self;
}


- (NSError *)error;
{
    return _error ? _error : _parser.parserError;
}


- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;
{
    NSString *prefix = [_prefixToNamespace firstForSecond:namespace];
    if ( ! prefix.length) return attribute;
    
    return [NSString stringWithFormat:@"%@:%@", prefix, attribute];
}


- (void)       parser:(NSXMLParser *)parser
didStartMappingPrefix:(NSString *)prefix
                toURI:(NSString *)namespaceURI;
{
    [_prefixToNamespace setFirst:prefix forSecond:namespaceURI];
}


- (void)     parser:(NSXMLParser *)parser
didEndMappingPrefix:(NSString *)prefix;
{
    [_prefixToNamespace removeFirst:prefix];
}


- (void)parser:(NSXMLParser *)parser
    foundCDATA:(NSData *)CDATABlock;
{
    if (_characters) {
        NSString *string = [[NSString alloc] initWithData:CDATABlock
                                                 encoding:NSUTF8StringEncoding];
        [_characters addObject:string];
    }
}


- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string;
{
    if (_characters) [_characters addObject:string];
}


@end
