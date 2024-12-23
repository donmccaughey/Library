#import "Library.h"

#import "Book.h"
#import "FileMatcher.h"


NSNotificationName const WillStartScanningForBooksNotification = @"WillStartScanningForBooks";
NSNotificationName const DidFinishScanningForBooksNotification = @"DidFinishScanningForBooks";


void
addMatchingPaths(NSString *dir, NSArray<FileMatcher *> *matchers, NSMutableOrderedSet<Book *> *books);


@implementation Library
{
    NSMutableOrderedSet<Book *> *_books;
}


- (NSOrderedSet<Book *> *)books;
{
    return _books;
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
        _books = [NSMutableOrderedSet new];
        _dirs = [dirs copy];
    }
    return self;
}


- (void)startScanningForBooks;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WillStartScanningForBooksNotification
                                                        object:self];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableOrderedSet<Book *> *books = [NSMutableOrderedSet new];
        for (NSString *dir in self->_dirs) {
            addMatchingPaths(dir, [Book fileMatchers], books);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_books = books;
            [[NSNotificationCenter defaultCenter] postNotificationName:DidFinishScanningForBooksNotification
                                                                object:self];
        });
    });
}


- (void)sortBy:(NSArray<NSSortDescriptor *> *)descriptors;
{
    [_books sortUsingDescriptors:descriptors];
}


@end


void
addMatchingPaths(NSString *dir, NSArray<FileMatcher *> *matchers, NSMutableOrderedSet<Book *> *books)
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:dir];
    
    NSString *relPath;
    while ((relPath = [enumerator nextObject])) {
        if (NSFileTypeRegular == enumerator.fileAttributes.fileType) {
            if ([Book isBookFile:relPath]) {
                NSString *absPath = [dir stringByAppendingPathComponent:relPath];
                Book *book = [[Book alloc] initWithPath:absPath
                                            andFileSize:enumerator.fileAttributes[NSFileSize]];
                [books addObject:book];
            }
        }
    }
}
