#import "Book.h"

#import "EPUBMatcher.h"
#import "PDFMatcher.h"


@implementation Book


+ (NSArray<FileMatcher *> *)fileMatchers;
{
    return @[
        [EPUBMatcher new],
        [PDFMatcher new],
    ];
}


- (instancetype)init;
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
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


- (BOOL)isEqual:(id)object;
{
    if (self == object) return YES;
    if ( ! [object isKindOfClass:[Book class]]) return NO;
    Book *book = object;
    return [self.path isEqual:book->_path];
}


- (NSUInteger)hash;
{
    return _path.hash;
}


@end
