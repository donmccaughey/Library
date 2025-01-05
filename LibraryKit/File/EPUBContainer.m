#import "EPUBContainer.h"

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


@implementation EPUBContainer
{
    BOOL _inContainerTag;
    BOOL _inRootfilesTag;
    NSMutableArray<EPUBRootfile *> *_rootfiles;
}


- (nullable instancetype)initWithData:(NSData *)containerXML
                                error:(NSError **)error;
{
    self = [super initWithData:containerXML
          shouldFindCharacters:NO];
    if ( ! self) return nil;
    
    _rootfiles = [NSMutableArray new];
    
    [_parser parse];
    
    if (self.error) {
        if (error) *error = self.error;
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


@end
