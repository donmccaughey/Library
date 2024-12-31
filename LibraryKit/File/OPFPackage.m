#import "OPFPackage.h"


static NSString *const dublinCoreURI = @"http://purl.org/dc/elements/1.1/";
static NSString *const opfURI = @"http://www.idpf.org/2007/opf";


static BOOL
isMetadataTag(NSString *namespaceURI, NSString *elementName)
{
    return [opfURI isEqualToString:namespaceURI]
        && [@"metadata" isEqualToString:elementName];
}


static BOOL
isTitleTag(NSString *namespaceURI, NSString *elementName)
{
    return [dublinCoreURI isEqualToString:namespaceURI]
        && [@"title" isEqualToString:elementName];
}


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
    if (isMetadataTag(namespaceURI, elementName)) {
        _inMetadataTag = YES;
    }
    
    if (_inMetadataTag) {
        if (isTitleTag(namespaceURI, elementName)) {
            _inTitleTag = YES;
        }
    }
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(nonnull NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName;
{
    if (isMetadataTag(namespaceURI, elementName)) {
        _inMetadataTag = NO;
    }
    if (isTitleTag(namespaceURI, elementName)) {
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
