#import "EPUBContainer.h"

#import "Errors.h"
#import "EPUBRootfile.h"


static NSString *const ctr = @"urn:oasis:names:tc:opendocument:xmlns:container";


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
    if (_inContainerTag) {
        if (_inRootfilesTag) {
            if ([self is:ctr:@"rootfile" equalTo:namespaceURI:elementName]) {
                NSString *mediaType = attributes[@"media-type"];
                if ( ! mediaType) return;
                
                NSString *fullPath = attributes[@"full-path"];
                if ( ! fullPath) return;

                EPUBRootfile *rootfile = [[EPUBRootfile alloc] initWithMediaType:mediaType
                                                                     andFullPath:fullPath];
                [_rootfiles addObject:rootfile];
            }
        } else if ([self is:ctr:@"rootfiles" equalTo:namespaceURI:elementName]) {
            _inRootfilesTag = YES;
        }
    } else if ([self is:ctr:@"container" equalTo:namespaceURI:elementName]) {
        _inContainerTag = YES;
                
        NSString *version = attributes[@"version"];
        if ( ! [@"1.0" isEqualToString:version]) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingContainerXML
                                        andMessage:@"The <container> element must be version 1.0 but was '%@'", version];
            [parser abortParsing];
        }
    }
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName;
{
    if (_inContainerTag) {
        if ([self is:ctr:@"rootfiles" equalTo:namespaceURI:elementName]) {
            _inRootfilesTag = NO;
        }
    } else if ([self is:ctr:@"container" equalTo:namespaceURI:elementName]) {
        _inContainerTag = NO;
    }
}


@end
