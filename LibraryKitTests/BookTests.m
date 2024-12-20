@import XCTest;
@import LibraryKit;


@interface BookTests : XCTestCase
@end


@implementation BookTests


- (void)testInitWithPath
{
    Book *book = [[Book alloc] initWithPath:@"example/path"
                                andFileSize:@0];
    
    XCTAssertEqual(book.fileSize, @0);
    XCTAssertEqual(book.path, @"example/path");
}


@end
