#import "OPFPackage.h"

#import "Errors.h"
#import "OPFIdentifier.h"


static NSString *const dc = @"http://purl.org/dc/elements/1.1/";
static NSString *const opf = @"http://www.idpf.org/2007/opf";


@implementation OPFPackage
{
    NSDictionary *_attributes;
    NSMutableArray<OPFIdentifier *> *_identifiers;
    BOOL _inMetadataTag;
    BOOL _inPackageTag;
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
            if ([self is: dc:@"identifier" equalTo: namespaceURI:elementName]) {
                _attributes = attributes;
            }
        } else if ([self is: opf:@"metadata" equalTo: namespaceURI:elementName]) {
            _inMetadataTag = YES;
        }
    } else if ([self is: opf:@"package" equalTo: namespaceURI:elementName]) {
        _inPackageTag = YES;
        
        NSString *version = attributes[[self q: opf:@"version"]];
        if ( ! [@"2.0" isEqualToString:version] && ! [@"3.0" isEqualToString:version]) {
            _error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                      andMessage:@"The <package> element must be version 2.0 or 3.0 but was '%@'", version];
            [parser abortParsing];
            return;
        }
        _version = version;
        
        NSString *uniqueIdentifier = attributes[[self q: opf:@"unique-identifier"]];
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
            if ([self is: dc:@"identifier" equalTo: namespaceURI:elementName]) {
                NSString *value = [self trimmedCharacters];
                if (value.length) {
                    OPFIdentifier *identifier = [[OPFIdentifier alloc] initWithScheme:_attributes[[self q: opf:@"scheme"]]
                                                                        andIdentifier:value];
                    [_identifiers addObject:identifier];
                    if ([_uniqueIdentifierID isEqualToString:_attributes[@"id"]]) {
                        _uniqueIdentifier = identifier;
                    }
                }
                _attributes = nil;
            } else if ([self is: dc:@"title" equalTo: namespaceURI:elementName]) {
                NSString *title = [self trimmedCharacters];
                if (title.length) [_titles addObject:title];
            }
        } else if ([self is: opf:@"metadata" equalTo: namespaceURI:elementName]) {
            _inMetadataTag = NO;
        }
    } else if ([self is: opf:@"package" equalTo: namespaceURI:elementName]) {
        _inPackageTag = NO;
    }
    
    [_characters removeAllObjects];
}


@end
