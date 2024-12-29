#import "OPFPackage.h"


static NSString *const dublinCoreURI = @"http://purl.org/dc/elements/1.1/";


@implementation OPFPackage
{
    NSMutableArray<NSError *> *_errors;
    BOOL _inMetadataTag;
    BOOL _inTitleTag;
    NSMutableString *_title;
}


- (instancetype)initWithData:(NSData *)containerXml {
    self = [super init];
    if ( ! self) return nil;
    
    _errors = [NSMutableArray new];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:containerXml];
    parser.delegate = self;
    parser.shouldProcessNamespaces = YES;
    [parser parse];
    
    return self;
}


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributes;
{
    if ([@"metadata" isEqualToString:elementName]) {
        _inMetadataTag = YES;
    }
    
    if (_inMetadataTag) {
        if ([@"title" isEqualToString:elementName] && [dublinCoreURI isEqualToString:namespaceURI]) {
            _inTitleTag = YES;
        }
    }
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(nonnull NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName;
{
    if ([@"metadata" isEqualToString:elementName]) {
        _inMetadataTag = NO;
    }
    if ([@"title" isEqualToString:elementName]) {
        _inTitleTag = NO;
    }
}


- (void)parser:(NSXMLParser *)parser
    foundCDATA:(NSData *)CDATABlock;
{
    if (_inTitleTag) {
        _title = _title ?: [NSMutableString new];
        NSString *string = [[NSString alloc] initWithData:CDATABlock
                                                 encoding:NSUTF16StringEncoding];
        [_title appendString:string];
    }
}


- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string;
{
    if (_inTitleTag) {
        _title = _title ?: [NSMutableString new];
        [_title appendString:string];
    }
}


- (void)    parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError;
{
    [_errors addObject:parseError];
}


@end
