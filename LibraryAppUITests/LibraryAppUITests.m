@import XCTest;


@interface LibraryAppUITests : XCTestCase
@end


@implementation LibraryAppUITests

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
