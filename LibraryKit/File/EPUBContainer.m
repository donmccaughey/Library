#import "EPUBContainer.h"

#import "BiMap.h"
#import "Errors.h"
#import "EPUBRootfile.h"


static NSString *const containerURI = @"urn:oasis:names:tc:opendocument:xmlns:container";


static BOOL
isContainerTag(NSString *namespaceURI, NSString *elementName)
{
    return [containerURI isEqualToString:namespaceURI]
        && [@"container" isEqualToString:elementName];
}


static BOOL
isRootfileTag(NSString *namespaceURI, NSString *elementName)
{
    return [containerURI isEqualToString:namespaceURI]
        && [@"rootfile" isEqualToString:elementName];
}


static BOOL
isRootfilesTag(NSString *namespaceURI, NSString *elementName)
{
    return [containerURI isEqualToString:namespaceURI]
        && [@"rootfiles" isEqualToString:elementName];
}


@interface EPUBContainer ()

- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;

@end


@implementation EPUBContainer
{
    NSError *_error;
    BOOL _inContainerTag;
    BOOL _inRootfilesTag;
    NSError *_parseError;
    BiMap<NSString *, NSString *> *_prefixToNamespace;
    NSMutableArray<EPUBRootfile *> *_rootfiles;
}


- (nullable instancetype)initWithData:(NSData *)containerXml
                                error:(NSError **)error;
{
    self = [super init];
    if ( ! self) return nil;
    
    _prefixToNamespace = [BiMap new];
    _rootfiles = [NSMutableArray new];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:containerXml];
    parser.delegate = self;
    parser.shouldProcessNamespaces = YES;
    parser.shouldReportNamespacePrefixes = YES;
    [parser parse];
    
    if (_error) {
        if (error) *error = _error;
        return nil;
    }
    
    if (_parseError) {
        if (error) *error = _parseError;
        return nil;
    }
    
    for (EPUBRootfile *rootfile in _rootfiles) {
        if (rootfile.isPackage) {
            _packagePath = rootfile.fullPath;
            break;
        }
    }
    
    if ( ! _packagePath) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingContainerXML
                                        andMessage:@"Did not find a <rootfile> with media type application/oebps-package+xml"];
            return nil;
        }
    }
    
    return self;
}


- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;
{
    NSString *prefix = [_prefixToNamespace firstForSecond:namespace];
    if ( ! prefix.length) return attribute;
    
    return [NSString stringWithFormat:@"%@:%@", prefix, attribute];
}


- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributes;
{
    if (isContainerTag(namespaceURI, elementName)) {
        _inContainerTag = YES;
        
        NSString *versionAttribute = [self attribute:@"version" withNamespace:containerURI];
        NSString *version = attributes[versionAttribute];
        if ( ! [@"1.0" isEqualToString:version]) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingContainerXML
                                        andMessage:@"The <container> element must be version 1.0 but was '%@'", version];
            [parser abortParsing];
        }
    } else if (_inContainerTag && isRootfilesTag(namespaceURI, elementName)) {
        _inRootfilesTag = YES;
    } else if (_inRootfilesTag && isRootfileTag(namespaceURI, elementName)) {
        NSString *mediaTypeAttribute = [self attribute:@"media-type" withNamespace:containerURI];
        NSString *mediaType = attributes[mediaTypeAttribute];
        if ( ! mediaType) return;
        
        NSString *fullPathAttribute = [self attribute:@"full-path" withNamespace:containerURI];
        NSString *fullPath = attributes[fullPathAttribute];
        if ( ! fullPath) return;

        EPUBRootfile *rootfile = [[EPUBRootfile alloc] initWithMediaType:mediaType
                                                             andFullPath:fullPath];
        [_rootfiles addObject:rootfile];
    }
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName;
{
    if (isContainerTag(namespaceURI, elementName)) {
        _inContainerTag = NO;
    } else if (_inContainerTag && isRootfilesTag(namespaceURI, elementName)) {
        _inRootfilesTag = NO;
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
