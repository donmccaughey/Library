#import "OPFPackage.h"

#import "Errors.h"
#import "OPFIdentifier.h"


static NSString *const dublinCoreURI = @"http://purl.org/dc/elements/1.1/";
static NSString *const opfURI = @"http://www.idpf.org/2007/opf";


@implementation OPFPackage
{
    NSMutableArray<OPFIdentifier *> *_identifiers;
    BOOL _inMetadataTag;
    BOOL _inPackageTag;
    NSString *_packageVersion;
    NSMutableArray<NSString *> *_titles;
    NSString *_uniqueIdentifierID;
}


- (nullable instancetype)initWithData:(NSData *)packageXML
                                error:(NSError **)error;
{
    self = [super initWithData:packageXML
          shouldFindCharacters:YES];
    if ( ! self) return nil;
    
    _identifiers = [NSMutableArray new];
    _titles = [NSMutableArray new];

    [_parser parse];
    
    if (self.error) {
        if (error) *error = self.error;
        return nil;
    }

    for (OPFIdentifier *identifier in _identifiers) {
        if ([_uniqueIdentifierID isEqualToString:identifier.ID]) {
            _uniqueIdentifier = identifier;
            break;
        }
    }
    if ( ! _uniqueIdentifier) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                        andMessage:@"Unique identifier not found in package metadata"];
        }
        return nil;
    }
    
    if ( ! _titles.count) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                        andMessage:@"No titles found in package metadata"];
        }
        return nil;
    }
    
    return self;
}


- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributes;
{
    if (_inPackageTag) {
        if (_inMetadataTag) {
            if ([self is: dublinCoreURI:@"identifier" equalTo: namespaceURI:elementName]) {
                NSString *ID = attributes[@"id"];
                NSString *scheme = attributes[[self q: opfURI:@"scheme"]];

                OPFIdentifier *identifier = [[OPFIdentifier alloc] initWithID:ID
                                                                    andScheme:scheme];
                [_identifiers addObject:identifier];
            }
        } else if ([self is: opfURI:@"metadata" equalTo: namespaceURI:elementName]) {
            _inMetadataTag = YES;
        }
    } else if ([self is: opfURI:@"package" equalTo: namespaceURI:elementName]) {
        _inPackageTag = YES;
        
        NSString *version = attributes[[self q: opfURI:@"version"]];
        if ( ! [@"2.0" isEqualToString:version] && ! [@"3.0" isEqualToString:version]) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                      andMessage:@"The <package> element must be version 2.0 or 3.0 but was '%@'", version];
            [parser abortParsing];
            return;
        }
        _packageVersion = version;
        
        NSString *uniqueIdentifier = attributes[[self q: opfURI:@"unique-identifier"]];
        if ( ! uniqueIdentifier.length) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                      andMessage:@"The <package> element must have a unique-identifier attribute"];
            [parser abortParsing];
            return;
        }
        _uniqueIdentifierID = uniqueIdentifier;
    }
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(nonnull NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName;
{
    if (_inPackageTag) {
        if (_inMetadataTag) {
            if ([self is: dublinCoreURI:@"identifier" equalTo: namespaceURI:elementName]) {
                NSString *identifier = [self trimmedCharacters];
                if (identifier.length) {
                    _identifiers.lastObject.identifier = identifier;
                } else {
                    [_identifiers removeLastObject];
                }
            } else if ([self is: dublinCoreURI:@"title" equalTo: namespaceURI:elementName]) {
                NSString *title = [self trimmedCharacters];
                if (title.length) [_titles addObject:title];
            }
        } else if ([self is: opfURI:@"metadata" equalTo: namespaceURI:elementName]) {
            _inMetadataTag = NO;
        }
    } else if ([self is: opfURI:@"package" equalTo: namespaceURI:elementName]) {
        _inPackageTag = NO;
    }
    
    [_characters removeAllObjects];
}


@end
