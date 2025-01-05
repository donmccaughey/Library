#import "XML.h"


@implementation XML


- (instancetype)initWithData:(NSData *)xml
        shouldFindCharacters:(BOOL)shouldFindCharacters;
{
    self = [super init];
    if ( ! self) return nil;

    _namespaceMap = [XMLNamespaceMap new];
    
    _parser = [[NSXMLParser alloc] initWithData:xml];
    _parser.delegate = self;
    _parser.shouldProcessNamespaces = YES;
    _parser.shouldReportNamespacePrefixes = YES;
    
    if (shouldFindCharacters) _characters = [NSMutableArray new];
    
    return self;
}


- (NSError *)error;
{
    return _error ? _error : _parser.parserError;
}


- (BOOL)is:(NSString *)namespaceURI1 :(NSString *)name1
   equalTo:(NSString *)namespaceURI2 :(NSString *)name2;
{
    return [namespaceURI1 isEqualToString:namespaceURI2]
        && [name1 isEqualToString:name2];
}


- (NSString *)trimmedCharacters;
{
    NSString *string = [_characters componentsJoinedByString:@""];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)valueForQualifiedName:(NSString *)namespaceURI :(NSString *)name
                     fromAttributes:(NSDictionary<NSString *, NSString *> *)attributes;
{
    NSSet<NSString *> *qNames = [_namespaceMap qualifiedNamesForAttribute:name
                                                              inNamespace:namespaceURI];
    for (NSString *qName in qNames) {
        NSString *value = attributes[qName];
        if (value) return value;
    }
    return nil;
}


- (void)       parser:(NSXMLParser *)parser
didStartMappingPrefix:(NSString *)prefix
                toURI:(NSString *)namespaceURI;
{
    [_namespaceMap pushPrefix:prefix forNamespaceURI:namespaceURI];
}


- (void)     parser:(NSXMLParser *)parser
didEndMappingPrefix:(NSString *)prefix;
{
    [_namespaceMap popPrefix:prefix];
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
