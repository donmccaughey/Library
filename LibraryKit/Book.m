#import "Book.h"

#import "EPUBMatcher.h"
#import "PDFMatcher.h"


BOOL
isOneWord(NSString *const string);

NSString *
makeTitleFromPath(NSString *path);


@implementation Book


+ (NSArray<FileMatcher *> *)fileMatchers;
{
    return @[
        [EPUBMatcher new],
        [PDFMatcher new],
    ];
}


+ (BOOL)isBookFile:(NSString *)path;
{
    for (FileMatcher *matcher in [self fileMatchers]) {
        if ([matcher pathMatches:path]) return true;
    }
    return false;
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
        _title = makeTitleFromPath(path);
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


BOOL
isOneWord(NSString *const string)
{
    NSRange range = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    return NSNotFound == range.location;
}


NSString *
makeTitleFromPath(NSString *path)
{
    NSString *filename = path.lastPathComponent.stringByDeletingPathExtension;
    if (isOneWord(filename)) {
        if ([filename containsString:@"_"]) {
            return [filename stringByReplacingOccurrencesOfString:@"_"
                                                       withString:@" "];
        }
    }
    return filename;
}
