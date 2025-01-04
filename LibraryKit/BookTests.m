@import XCTest;
@import LibraryKit;


@interface NSDate (Tests)

+ (NSDate *)dateWithISODate:(NSString *)isoDate;

- (BOOL)isEqualToISODate:(NSString *)isoDate;

@end


@interface BookTests : XCTestCase
@end


@implementation BookTests


- (void)testInitWithPathForEPUB
{
    NSDictionary<NSFileAttributeKey, id> *attributes = @{
        NSFileSize: @123456,
        NSFileCreationDate: [NSDate dateWithISODate:@"2001-01-01 01:01:01Z"],
        NSFileModificationDate: [NSDate dateWithISODate:@"2020-02-20 20:20:20Z"],
    };
    Book *book = [[Book alloc] initWithPath:@"example/path/title.epub"
                          andFileAttributes:attributes];
    
    XCTAssertTrue([book.fileCreationDate isEqualToISODate:@"2001-01-01 01:01:01Z"]);
    XCTAssertTrue([book.fileModificationDate isEqualToISODate:@"2020-02-20 20:20:20Z"]);
    XCTAssertEqual(book.fileSize, 123456);
    XCTAssertEqual(book.format, FormatEPUB);
    XCTAssertEqualObjects(book.path, @"example/path/title.epub");
    XCTAssertEqualObjects(book.title, @"title");
    
    XCTAssertNil(book.error);
    XCTAssertEqual(book.pageCount, 0);
    XCTAssertFalse(book.scanFailed);
    XCTAssertNil(book.scanTime);
    XCTAssertFalse(book.wasScanned);
}


- (void)testInitWithPathForPDF
{
    NSDictionary<NSFileAttributeKey, id> *attributes = @{
        NSFileSize: @123456,
        NSFileCreationDate: [NSDate dateWithISODate:@"2001-01-01 01:01:01Z"],
        NSFileModificationDate: [NSDate dateWithISODate:@"2020-02-20 20:20:20Z"],
    };
    Book *book = [[Book alloc] initWithPath:@"example/path/title.pdf"
                          andFileAttributes:attributes];
    
    XCTAssertTrue([book.fileCreationDate isEqualToISODate:@"2001-01-01 01:01:01Z"]);
    XCTAssertTrue([book.fileModificationDate isEqualToISODate:@"2020-02-20 20:20:20Z"]);
    XCTAssertEqual(book.fileSize, 123456);
    XCTAssertEqual(book.format, FormatPDF);
    XCTAssertEqualObjects(book.path, @"example/path/title.pdf");
    XCTAssertEqualObjects(book.title, @"title");
    
    XCTAssertNil(book.error);
    XCTAssertEqual(book.pageCount, 0);
    XCTAssertFalse(book.scanFailed);
    XCTAssertNil(book.scanTime);
    XCTAssertFalse(book.wasScanned);
}


- (void)testInitWithPathForUnknownExtension
{
    NSDictionary<NSFileAttributeKey, id> *attributes = @{
        NSFileSize: @123456,
        NSFileCreationDate: [NSDate dateWithISODate:@"2001-01-01 01:01:01Z"],
        NSFileModificationDate: [NSDate dateWithISODate:@"2020-02-20 20:20:20Z"],
    };
    Book *book = [[Book alloc] initWithPath:@"example/path/title.nope"
                          andFileAttributes:attributes];
    
    XCTAssertNil(book);
}


@end


@implementation NSDate (Tests)

+ (NSDate *)dateWithISODate:(NSString *)isoDate;
{
    NSAssert(isoDate && isoDate.length, @"Expected an ISO date string");
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"C"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss'Z'";
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    });
    
    return [formatter dateFromString:isoDate];
}


- (BOOL)isEqualToISODate:(NSString *)isoDate;
{
    return [self isEqualToDate:[NSDate dateWithISODate:isoDate]];
}


@end
