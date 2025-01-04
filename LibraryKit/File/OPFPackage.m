#import "OPFPackage.h"

#import "BiMap.h"
#import "Errors.h"


static NSString *const dublinCoreURI = @"http://purl.org/dc/elements/1.1/";
static NSString *const opfURI = @"http://www.idpf.org/2007/opf";


static BOOL
isMetadataTag(NSString *namespaceURI, NSString *elementName)
{
    return [opfURI isEqualToString:namespaceURI]
        && [@"metadata" isEqualToString:elementName];
}


static BOOL
isPackageTag(NSString *namespaceURI, NSString *elementName)
{
    return [opfURI isEqualToString:namespaceURI]
        && [@"package" isEqualToString:elementName];
}


static BOOL
isTitleTag(NSString *namespaceURI, NSString *elementName)
{
    return [dublinCoreURI isEqualToString:namespaceURI]
        && [@"title" isEqualToString:elementName];
}


@interface OPFPackage ()

- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;

@end


@implementation OPFPackage
{
    NSError *_error;
    BOOL _inMetadataTag;
    BOOL _inPackageTag;
    BOOL _inTitleTag;
    NSString *_packageVersion;
    NSError *_parseError;
    BiMap<NSString *, NSString *> *_prefixToNamespace;
    NSMutableString *_title;
}


- (instancetype)initWithData:(NSData *)containerXml
                       error:(NSError **)error;
{
    self = [super init];
    if ( ! self) return nil;
    
    _prefixToNamespace = [BiMap new];

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:containerXml];
    parser.delegate = self;
    parser.shouldProcessNamespaces = YES;
    [parser parse];
    
    if (_error) {
        if (error) *error = _error;
        return nil;
    }
    
    if (_parseError) {
        if (error) *error = _parseError;
        return nil;
    }
    
    return self;
}


- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;
{
    NSString *prefix = [_prefixToNamespace firstForSecond:namespace];
    if ( ! prefix.length) return attribute;
    
    return [NSString stringWithFormat:@"%@:%@", prefix, namespace];
}


- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributes;
{
    if (isPackageTag(namespaceURI, elementName)) {
        _inPackageTag = YES;
        
        NSString *versionAttr = [self attribute:@"version" withNamespace:opfURI];
        NSString *version = attributes[versionAttr];
        if ( ! [@"2.0" isEqualToString:version] && ! [@"3.0" isEqualToString:version]) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                      andMessage:@"The <package> element must be version 2.0 or 3.0 but was '%@'", version];
            [parser abortParsing];
            return;
        }
        _packageVersion = version;
        
        NSString *uniqueIdentifierAttribute = [self attribute:@"unique-identifier" withNamespace:opfURI];
        NSString *uniqueIdentifier = attributes[uniqueIdentifierAttribute];
        if ( ! uniqueIdentifier || ! uniqueIdentifier.length) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                      andMessage:@"The <package> element must have a unique-identifier attribute"];
            [parser abortParsing];
            return;
        }
        _uniqueIdentifier = uniqueIdentifier;
        
    } else if (_inPackageTag && isMetadataTag(namespaceURI, elementName)) {
        _inMetadataTag = YES;
    } else if (_inMetadataTag) {
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
    if (isPackageTag(namespaceURI, elementName)) {
        _inPackageTag = NO;
    } else if (isMetadataTag(namespaceURI, elementName)) {
        _inMetadataTag = NO;
    } else if (isTitleTag(namespaceURI, elementName)) {
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


- (void)    parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError;
{
    _parseError = parseError;
}


@end
