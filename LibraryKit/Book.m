#import "Book.h"

#import "PDFFileMatcher.h"


@implementation Book


+ (NSArray<FileMatcher *> *)fileMatchers;
{
    return @[
        [PDFFileMatcher new],
    ];
}


- (instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}


- (NSString *)description;
{
    return _path;
}


@end
