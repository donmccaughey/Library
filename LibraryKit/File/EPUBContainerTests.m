@import XCTest;
#import "EPUBContainer.h"


@interface EPUBContainerTests : XCTestCase

- (NSData *)dataFromLines:(NSArray<NSString *> *)lines;

@end


@implementation EPUBContainerTests


- (void)testInitWithDataError;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNotNil(container);
    XCTAssertEqualObjects(container.packagePath, @"OEBPS/Great Expectations.opf");
}


- (void)testInitWithDataErrorForAlternateRenditions;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.pdf' media-type='application/pdf' />\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNotNil(container);
    XCTAssertEqualObjects(container.packagePath, @"OEBPS/Great Expectations.opf");
}


- (void)testInitWithDataErrorForMultipleRootfiles;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='first.opf' media-type='application/oebps-package+xml' />\n",
        @"        <rootfile full-path='second.opf' media-type='application/oebps-package+xml' />\n",
        @"        <rootfile full-path='third.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNotNil(container);
    XCTAssertEqualObjects(container.packagePath, @"first.opf");
}


- (void)testInitWithDataErrorForMissingVersion;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForUnknownVersion;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='2.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForMissingNamespace;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForUnknownNamespace;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='not-a-real-namespace'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForIncompleteRootfileTags;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile media-type='application/oebps-package+xml' />\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.opf' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorSkipsIncompleteRootfileTags;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile media-type='application/oebps-package+xml' />\n",
        @"        <rootfile full-path='first.opf' />\n",
        @"        <rootfile full-path='second.opf' media-type='application/oebps-package+xml' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNotNil(container);
    XCTAssertEqualObjects(container.packagePath, @"second.opf");
}


- (void)testInitWithDataErrorForOnlyAlternateRendition;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"        <rootfile full-path='OEBPS/Great Expectations.pdf' media-type='application/pdf' />\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorWhenNoRootfileTags;
{
    NSData *data = [self dataFromLines:@[
        @"<?xml version='1.0'?>\n",
        @"<container version='1.0' xmlns='urn:oasis:names:tc:opendocument:xmlns:container'>\n",
        @"    <rootfiles>\n",
        @"    </rootfiles>\n",
        @"</container>\n",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (void)testInitWithDataErrorForBadXML;
{
    NSData *data = [self dataFromLines:@[
        @"This is not XML",
    ]];
    
    NSError *error = nil;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&error];
    
    XCTAssertNil(container);
    XCTAssertNotNil(error);
}


- (NSData *)dataFromLines:(NSArray<NSString *> *)lines;
{
    NSString *text = [lines componentsJoinedByString:@""];
    return [text dataUsingEncoding:NSUTF8StringEncoding];
}


@end
