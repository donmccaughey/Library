#import "Book.h"
#import "Book-internal.h"

#import "EPUBBook.h"
#import "EPUBMatcher.h"
#import "PDFBook.h"
#import "PDFMatcher.h"


BOOL
isOneWord(NSString *const string);

NSString *
makeTitleFromPath(NSString *path);


@implementation Book


+ (NSArray<FileMatcher *> *)fileMatchers;
{
    return @[
        [EPUBMatcher matcher],
        [PDFMatcher matcher],
    ];
}


+ (BOOL)isBookFile:(NSString *)path;
{
    for (FileMatcher *matcher in [self fileMatchers]) {
        if ([matcher pathMatches:path]) return true;
    }
    return false;
}


- (NSUInteger)pageCount;
{
    return 0;
}


- (instancetype)init;
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    if ([[EPUBMatcher matcher] pathMatches:path]) {
        return [[EPUBBook alloc] initWithPath:path
                                  andFileSize:fileSize];
    }
    if ([[PDFMatcher matcher] pathMatches:path]) {
        return [[PDFBook alloc] initWithPath:path
                                 andFileSize:fileSize];
    }
    [NSException raise:@"Invalid book path"
                format:@"The path '%@' is not a valid book format.", path];
    return nil;
}


- (instancetype)initWithType:(enum BookType)type
                    typeName:(NSString *)typeName
                        path:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    self = [super init];
    if (self) {
        _fileSize = fileSize;
        _path = path;
        _title = makeTitleFromPath(path);
        _type = type;
        _typeName = typeName;
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
