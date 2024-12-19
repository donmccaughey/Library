@import XCTest;


@interface LibraryMacUITests : XCTestCase
@end


@implementation LibraryMacUITests

- (void)setUp;
{
    self.continueAfterFailure = NO;
}


- (void)tearDown;
{
}


- (void)testExample;
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
}

@end
