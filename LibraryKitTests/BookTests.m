@import XCTest;
@import LibraryKit;


@interface BookTests : XCTestCase
@end


@implementation BookTests


- (void)testInitWithPath
{
    Book *book = [[Book alloc] initWithPath:@"example/path"];
    
    XCTAssertEqual(book.path, @"example/path");
}


@end
