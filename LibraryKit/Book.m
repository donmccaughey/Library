#import "Book.h"

#import "PDFFileMatcher.h"


@implementation Book
{
    NSString *_title;
}


+ (NSArray<FileMatcher *> *)fileMatchers;
{
    return @[
        [PDFFileMatcher new],
    ];
}


- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    self = [super init];
    if (self) {
        _fileSize = fileSize;
        _path = path;
        _title = path.lastPathComponent;
    }
    return self;
}


- (NSString *)description;
{
    return _title;
}


- (NSString *)title;
{
    return _title;
}


@end
