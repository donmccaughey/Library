#import <XCTest/XCTest.h>

#import "XMLNamespaceMap.h"


static NSString *const dc = @"http://purl.org/dc/elements/1.1/";
static NSString *const opf = @"http://www.idpf.org/2007/opf";


@interface XMLNamespaceMapTests : XCTestCase
@end


@implementation XMLNamespaceMapTests


- (void)testEmptyNamespaceNap;
{
    XMLNamespaceMap *map = [XMLNamespaceMap new];
    
    XCTAssertNil([map namespaceURIForPrefix:@"dc"]);
    
    XCTAssertEqualObjects([NSSet set], [map prefixesForNamespaceURI:dc]);
    
    XCTAssertEqualObjects([NSSet set], [map qualifiedNamesForAttribute:@"title" inNamespace:dc]);
}


- (void)testDefaultNamespace;
{
    XMLNamespaceMap *map = [XMLNamespaceMap new];
    [map pushPrefix:@"" forNamespaceURI:opf];
    
    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@""]);
    
    XCTAssertEqualObjects([NSSet setWithObject:@""], [map prefixesForNamespaceURI:opf]);
    
    XCTAssertEqualObjects([NSSet set], [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
}


- (void)testPrefixedNamespace;
{
    XMLNamespaceMap *map = [XMLNamespaceMap new];
    [map pushPrefix:@"opf" forNamespaceURI:opf];
    
    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@"opf"]);
    
    XCTAssertEqualObjects([NSSet setWithObject:@"opf"], [map prefixesForNamespaceURI:opf]);
    
    XCTAssertEqualObjects([NSSet setWithObject:@"opf:title"], [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
}


- (void)testDefaultAndPrefixedNamespace;
{
    XMLNamespaceMap *map = [XMLNamespaceMap new];
    [map pushPrefix:@"" forNamespaceURI:opf];
    [map pushPrefix:@"opf" forNamespaceURI:opf];
    
    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@""]);
    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@"opf"]);
    
    NSSet *expected = [NSSet setWithObjects:@"", @"opf", nil];
    XCTAssertEqualObjects(expected, [map prefixesForNamespaceURI:opf]);
    
    XCTAssertEqualObjects([NSSet setWithObject:@"opf:title"], [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
}


- (void)testTwoDifferentPrefixesForSameNamespace;
{
    XMLNamespaceMap *map = [XMLNamespaceMap new];
    [map pushPrefix:@"pkg" forNamespaceURI:opf];
    [map pushPrefix:@"opf" forNamespaceURI:opf];

    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@"pkg"]);
    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@"opf"]);
    
    NSSet *expected = [NSSet setWithObjects:@"pkg", @"opf", nil];
    XCTAssertEqualObjects(expected, [map prefixesForNamespaceURI:opf]);
    
    expected = [NSSet setWithObjects:@"pkg:title", @"opf:title", nil];
    XCTAssertEqualObjects(expected, [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
}


- (void)testTwoDifferentNamespaces;
{
    XMLNamespaceMap *map = [XMLNamespaceMap new];
    [map pushPrefix:@"dc" forNamespaceURI:dc];
    [map pushPrefix:@"opf" forNamespaceURI:opf];
    
    XCTAssertEqualObjects(dc, [map namespaceURIForPrefix:@"dc"]);
    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@"opf"]);
    
    XCTAssertEqualObjects([NSSet setWithObject:@"dc"], [map prefixesForNamespaceURI:dc]);
    XCTAssertEqualObjects([NSSet setWithObject:@"opf"], [map prefixesForNamespaceURI:opf]);
    
    XCTAssertEqualObjects([NSSet setWithObject:@"dc:title"], [map qualifiedNamesForAttribute:@"title" inNamespace:dc]);
    XCTAssertEqualObjects([NSSet setWithObject:@"opf:title"], [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
}


- (void)testTwoDifferentNamespacesSamePrefix;
{
    XMLNamespaceMap *map = [XMLNamespaceMap new];
    [map pushPrefix:@"ns" forNamespaceURI:opf];
    [map pushPrefix:@"ns" forNamespaceURI:dc];

    XCTAssertEqualObjects(dc, [map namespaceURIForPrefix:@"ns"]);
    
    XCTAssertEqualObjects([NSSet set], [map prefixesForNamespaceURI:opf]);
    XCTAssertEqualObjects([NSSet setWithObject:@"ns"], [map prefixesForNamespaceURI:dc]);

    XCTAssertEqualObjects([NSSet set], [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
    XCTAssertEqualObjects([NSSet setWithObject:@"ns:title"], [map qualifiedNamesForAttribute:@"title" inNamespace:dc]);
    
    [map popPrefix:@"ns"];

    XCTAssertEqualObjects(opf, [map namespaceURIForPrefix:@"ns"]);
    
    XCTAssertEqualObjects([NSSet setWithObject:@"ns"], [map prefixesForNamespaceURI:opf]);
    XCTAssertEqualObjects([NSSet set], [map prefixesForNamespaceURI:dc]);

    XCTAssertEqualObjects([NSSet setWithObject:@"ns:title"], [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
    XCTAssertEqualObjects([NSSet set], [map qualifiedNamesForAttribute:@"title" inNamespace:dc]);
    
    [map popPrefix:@"ns"];

    XCTAssertNil([map namespaceURIForPrefix:@"ns"]);
    
    XCTAssertEqualObjects([NSSet set], [map prefixesForNamespaceURI:opf]);
    XCTAssertEqualObjects([NSSet set], [map prefixesForNamespaceURI:dc]);

    XCTAssertEqualObjects([NSSet set], [map qualifiedNamesForAttribute:@"title" inNamespace:opf]);
    XCTAssertEqualObjects([NSSet set], [map qualifiedNamesForAttribute:@"title" inNamespace:dc]);
}


@end
