@import XCTest;
#import "OPFPackage.h"

#import "OPFIdentifier.h"


@interface OPFPackageTests : XCTestCase

- (NSData *)dataFromLines:(NSArray<NSString *> *)lines;

@end


@implementation OPFPackageTests


- (void)testInitWithDataError;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNotNil(package);
    XCTAssertEqual(package.titles.count, 1);
    XCTAssertEqualObjects(package.titles.firstObject, @"Alice in Wonderland");
    XCTAssertEqualObjects(package.uniqueIdentifier.ID, @"BookId");
    XCTAssertEqualObjects(package.uniqueIdentifier.identifier, @"123456789X");
    XCTAssertEqualObjects(package.uniqueIdentifier.scheme, @"ISBN");
}


- (void)testInitWithDataErrorForVersion3_0;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='3.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNotNil(package);
    XCTAssertEqual(package.titles.count, 1);
    XCTAssertEqualObjects(package.titles.firstObject, @"Alice in Wonderland");
    XCTAssertEqualObjects(package.uniqueIdentifier.ID, @"BookId");
    XCTAssertEqualObjects(package.uniqueIdentifier.identifier, @"123456789X");
    XCTAssertEqualObjects(package.uniqueIdentifier.scheme, @"ISBN");
}


- (void)testInitWithDataErrorForMissingVersion;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForUnknownVersion;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='4.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForMissingNamespace;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForUnknownNamespace;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='not-a-real-namespace' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForMissingUniqueIdentifierAttribute;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='http://www.idpf.org/2007/opf'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForEmptyUniqueIdentifierAttribute;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier=''>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForTitleNotFound;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForUniqueIdentifierNotFound;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForMultipleTitles;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:title>Alicia in Terra Mirabili</dc:title>\n",
        @"        <dc:title>Aventures d'Alice au Pays des Merveilles</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId' opf:scheme='ISBN'>123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNotNil(package);
    XCTAssertEqual(package.titles.count, 3);
    XCTAssertEqualObjects(package.titles[0], @"Alice in Wonderland");
    XCTAssertEqualObjects(package.titles[1], @"Alicia in Terra Mirabili");
    XCTAssertEqualObjects(package.titles[2], @"Aventures d'Alice au Pays des Merveilles");
    XCTAssertEqualObjects(package.uniqueIdentifier.ID, @"BookId");
    XCTAssertEqualObjects(package.uniqueIdentifier.identifier, @"123456789X");
    XCTAssertEqualObjects(package.uniqueIdentifier.scheme, @"ISBN");
}


- (void)testInitWithDataErrorForUniqueIdentifierWithoutScheme;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<package version='2.0' xmlns='http://www.idpf.org/2007/opf' unique-identifier='BookId'>\n",
        @"    <metadata xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:opf='http://www.idpf.org/2007/opf'>\n",
        @"        <dc:title>Alice in Wonderland</dc:title>\n",
        @"        <dc:title>Alicia in Terra Mirabili</dc:title>\n",
        @"        <dc:title>Aventures d'Alice au Pays des Merveilles</dc:title>\n",
        @"        <dc:language>en</dc:language>\n",
        @"        <dc:identifier id='BookId'>urn:isbn:123456789X</dc:identifier>\n",
        @"        <dc:creator opf:role='aut'>Lewis Carroll</dc:creator>\n",
        @"    </metadata>\n",
        @"</package>\n",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNotNil(package);
    XCTAssertEqual(package.titles.count, 3);
    XCTAssertEqualObjects(package.titles[0], @"Alice in Wonderland");
    XCTAssertEqualObjects(package.titles[1], @"Alicia in Terra Mirabili");
    XCTAssertEqualObjects(package.titles[2], @"Aventures d'Alice au Pays des Merveilles");
    XCTAssertEqualObjects(package.uniqueIdentifier.ID, @"BookId");
    XCTAssertEqualObjects(package.uniqueIdentifier.identifier, @"urn:isbn:123456789X");
    XCTAssertNil(package.uniqueIdentifier.scheme);
}


- (void)testInitWithDataErrorForBadXML;
{
    NSData *data = [self dataFromLines:@[
        @"This is not XML",
    ]];
    
    NSError *error = nil;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&error];
    
    XCTAssertNil(package);
    XCTAssertNotNil(error);
}


- (NSData *)dataFromLines:(NSArray<NSString *> *)lines;
{
    NSString *text = [lines componentsJoinedByString:@""];
    return [text dataUsingEncoding:NSUTF8StringEncoding];
}


@end
