#import "EPUBContainer.h"

#import "EPUBRootfile.h"


static NSString *const containerURI = @"urn:oasis:names:tc:opendocument:xmlns:container";


static BOOL
isRootfileTag(NSString *namespaceURI, NSString *elementName)
{
    return [containerURI isEqualToString:namespaceURI]
        && [@"rootfile" isEqualToString:elementName];
}


@interface EPUBContainer ()

- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;

@end


@implementation EPUBContainer
{
    NSMutableDictionary<NSString *, NSString *> *_prefixForNamespace;
    NSMutableArray<EPUBRootfile *> *_rootfiles;
}


- (NSString *)attribute:(NSString *)attribute
          withNamespace:(NSString *)namespace;
{
    NSString *prefix = _prefixForNamespace[namespace];
    if ( ! prefix.length) return attribute;
    return [NSString stringWithFormat:@"%@:%@", prefix, namespace];
}


- (NSString *)firstPackagePath;
{
    for (EPUBRootfile *rootfile in _rootfiles) {
        if (rootfile.isPackage) return rootfile.fullPath;
    }
    return nil;
}


- (instancetype)initWithData:(NSData *)containerXml {
    self = [super init];
    if ( ! self) return nil;
    
    _prefixForNamespace = [NSMutableDictionary new];
    _rootfiles = [NSMutableArray new];
    
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
    if ( ! isRootfileTag(namespaceURI, elementName)) return;
    
    NSString *mediaTypeAttribute = [self attribute:@"media-type" withNamespace:containerURI];
    NSString *mediaType = attributes[mediaTypeAttribute];
    if ( ! mediaType) {
        NSLog(@"rootfile element missing media-type attribute");
        return;
    }
    
    NSString *fullPathAttribute = [self attribute:@"full-path" withNamespace:containerURI];
    NSString *fullPath = attributes[fullPathAttribute];
    if ( ! fullPath) {
        NSLog(@"rootfile element missing full-path attribute");
        return;
    }

    EPUBRootfile *rootfile = [[EPUBRootfile alloc] initWithMediaType:mediaType
                                                         andFullPath:fullPath];
    [_rootfiles addObject:rootfile];
}


- (void)       parser:(NSXMLParser *)parser
didStartMappingPrefix:(NSString *)prefix
                toURI:(NSString *)namespaceURI;
{
    _prefixForNamespace[namespaceURI] = prefix;
}


@end
