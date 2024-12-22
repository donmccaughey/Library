#import "Library.h"

#import "Book.h"
#import "FileMatcher.h"


NSNotificationName const LibraryWillStartScanningForBooksNotification = @"LibraryWillStartScanningForBooks";
NSNotificationName const LibraryDidFinishScanningForBooksNotification = @"LibraryDidFinishScanningForBooks";


void
addMatchingPaths(NSString *dir, NSArray<FileMatcher *> *matchers, NSMutableDictionary<NSString *, Book *> *booksByPath);


@implementation Library
{
    NSMutableDictionary<NSString *, Book *> *_booksByPath;
}


- (NSArray<Book *> *)books;
{
    return _booksByPath.allValues;
}


- (instancetype)init;
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (instancetype)initWithDir:(NSString *)dir;
{
    return [self initWithDirs:@[dir]];
}


- (instancetype)initWithDirs:(NSArray<NSString *> *)dirs;
{
    self = [super init];
    if (self) {
        _booksByPath = [NSMutableDictionary new];
        _dirs = [dirs copy];
    }
    return self;
}


- (void)startScanningForBooks;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LibraryWillStartScanningForBooksNotification
                                                        object:self];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableDictionary<NSString *, Book *> *booksByPath = [NSMutableDictionary new];
        for (NSString *dir in self->_dirs) {
            addMatchingPaths(dir, [Book fileMatchers], booksByPath);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_booksByPath = booksByPath;
            [[NSNotificationCenter defaultCenter] postNotificationName:LibraryDidFinishScanningForBooksNotification
                                                                object:self];
        });
    });
}


@end


bool
pathMatches(NSString *path, NSArray<FileMatcher *> *matchers)
{
    for (FileMatcher *matcher in matchers) {
        if ([matcher pathMatches:path]) return true;
    }
    return false;
}


void
addMatchingPaths(NSString *dir, NSArray<FileMatcher *> *matchers, NSMutableDictionary<NSString *, Book *> *booksByPath)
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:dir];
    
    NSString *relFilePath;
    while ((relFilePath = [enumerator nextObject])) {
        if (NSFileTypeRegular == enumerator.fileAttributes.fileType) {
            if (pathMatches(relFilePath, matchers)) {
                NSString *absFilePath = [dir stringByAppendingPathComponent:relFilePath];
                Book *book = [[Book alloc] initWithPath:absFilePath
                                            andFileSize:enumerator.fileAttributes[NSFileSize]];
                booksByPath[book.path] = book;
            }
        }
    }
}
