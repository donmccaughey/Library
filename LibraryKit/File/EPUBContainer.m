#import "EPUBContainer.h"

#import "EPUBRootfile.h"


@implementation EPUBContainer
{
    NSMutableArray<EPUBRootfile *> *_rootfiles;
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
    
    _rootfiles = [NSMutableArray new];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:containerXml];
    parser.delegate = self;
    [parser parse];
    
    return self;
}


- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributes;
{
    if ( ! [@"rootfile" isEqualToString:elementName]) return;
    
    NSString *mediaType = attributes[@"media-type"];
    if ( ! mediaType) {
        NSLog(@"rootfile element missing media-type attribute");
        return;
    }
    
    NSString *fullPath = attributes[@"full-path"];
    if ( ! fullPath) {
        NSLog(@"rootfile element missing full-path attribute");
        return;
    }

    EPUBRootfile *rootfile = [[EPUBRootfile alloc] initWithMediaType:mediaType
                                                         andFullPath:fullPath];
    [_rootfiles addObject:rootfile];
}


@end
