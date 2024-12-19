#import "Library.h"

@import Cocoa;

#import "Book.h"
#import "FileMatcher.h"


void addMatchingPaths(NSString *dir, NSArray<FileMatcher *> *matchers, NSMutableArray<Book *> *books);


@implementation Library


- (instancetype)initWithDir:(NSString *)dir;
{
    return [self initWithDirs:@[dir]];
}


- (instancetype)initWithDirs:(NSArray<NSString *> *)dirs;
{
    self = [super init];
    if (self) {
        _books = @[];
        _dirs = [dirs copy];
    }
    return self;
}


- (void)scanDirsForBooks;
{
    NSMutableArray<Book *> *books = [NSMutableArray new];
    for (NSString *dir in _dirs) {
        addMatchingPaths(dir, [Book fileMatchers], books);
    }
    _books = books;
}


@end


bool pathMatches(NSString *path, NSArray<FileMatcher *> *matchers)
{
    for (FileMatcher *matcher in matchers) {
        if ([matcher pathMatches:path]) return true;
    }
    return false;
}


void addMatchingPaths(NSString *dir, NSArray<FileMatcher *> *matchers, NSMutableArray<Book *> *books)
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:dir];
    NSString *file;
    while ((file = [enumerator nextObject])) {
        NSString *path = [dir stringByAppendingPathComponent:file];
        
        BOOL isDir;
        if ([manager fileExistsAtPath:path isDirectory:&isDir] && ! isDir) {
            if (pathMatches(path, matchers)) {
                Book *book = [[Book alloc] initWithPath:path];
                [books addObject:book];
            }
        }
    }
}
