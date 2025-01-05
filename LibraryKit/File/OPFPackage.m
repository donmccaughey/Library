#import "OPFPackage.h"

#import "Errors.h"
#import "OPFIdentifier.h"


static NSString *const dublinCoreURI = @"http://purl.org/dc/elements/1.1/";
static NSString *const opfURI = @"http://www.idpf.org/2007/opf";


static BOOL
isIdentifierTag(NSString *namespaceURI, NSString *elementName)
{
    return [dublinCoreURI isEqualToString:namespaceURI]
        && [@"identifier" isEqualToString:elementName];
}


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
    if (isPackageTag(namespaceURI, elementName)) {
        _inPackageTag = YES;
        
        NSString *version = attributes[[self ns:opfURI name:@"version"]];
        if ( ! [@"2.0" isEqualToString:version] && ! [@"3.0" isEqualToString:version]) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                      andMessage:@"The <package> element must be version 2.0 or 3.0 but was '%@'", version];
            [parser abortParsing];
            return;
        }
        _packageVersion = version;
        
        NSString *uniqueIdentifier = attributes[[self ns:opfURI name:@"unique-identifier"]];
        if ( ! uniqueIdentifier.length) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                      andMessage:@"The <package> element must have a unique-identifier attribute"];
            [parser abortParsing];
            return;
        }
        _uniqueIdentifierID = uniqueIdentifier;
    } else if (_inPackageTag && isMetadataTag(namespaceURI, elementName)) {
        _inMetadataTag = YES;
    } else if (_inMetadataTag) {
        if (isIdentifierTag(namespaceURI, elementName)) {
            NSString *ID = attributes[@"id"];
            NSString *scheme = attributes[[self ns:opfURI name:@"scheme"]];

            OPFIdentifier *identifier = [[OPFIdentifier alloc] initWithID:ID
                                                                andScheme:scheme];
            [_identifiers addObject:identifier];
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
    } else if (_inPackageTag && isMetadataTag(namespaceURI, elementName)) {
        _inMetadataTag = NO;
    } else if (_inMetadataTag) {
        if (isIdentifierTag(namespaceURI, elementName)) {
            NSString *identifier = [self trimmedCharacters];
            if (identifier.length) {
                _identifiers.lastObject.identifier = identifier;
            } else {
                [_identifiers removeLastObject];
            }
        } else if (isTitleTag(namespaceURI, elementName)) {
            NSString *title = [self trimmedCharacters];
            if (title.length) [_titles addObject:title];
        }
    }
    [_characters removeAllObjects];
}


@end
