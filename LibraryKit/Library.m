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
    NSArray<NSSortDescriptor *> *_sortDescriptors;
}


- (NSArray<NSSortDescriptor *> *)sortDescriptors;
{
    return [_sortDescriptors copy];
}


- (void)setSortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
{
    _sortDescriptors = [sortDescriptors copy];
    [_books sortUsingDescriptors:_sortDescriptors];
}


- (instancetype)init;
{
    self = [super init];
    if (self) {
        _books = [NSMutableOrderedSet new];
        _dirs = @[];
        _sortDescriptors = @[
            [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
            [NSSortDescriptor sortDescriptorWithKey:@"fileSize" ascending:YES],
        ];
    }
    return self;
}


- (void)sortBy:(NSArray<NSSortDescriptor *> *)descriptors;
{
    [_books sortUsingDescriptors:descriptors];
}


- (void)startScanningForBooksInDirs:(NSArray<NSString *> *)dirs;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WillStartScanningForBooksNotification
                                                        object:self];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableOrderedSet<Book *> *books = [NSMutableOrderedSet new];
        for (NSString *dir in dirs) {
            addMatchingPaths(dir, [Book fileMatchers], books);
        }
        [books sortUsingDescriptors:self->_sortDescriptors];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_books = books;
            self->_dirs = [dirs copy];
            [[NSNotificationCenter defaultCenter] postNotificationName:DidFinishScanningForBooksNotification
                                                                object:self];
        });
    });
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
