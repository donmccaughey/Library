#import "Library.h"

#import "Book.h"
#import "Stopwatch.h"


NSNotificationName const LibraryWillStartScanningFoldersNotification = @"LibraryWillStartFoldersScanning";
NSNotificationName const LibraryDidFinishScanningFoldersNotification = @"LibraryDidFinishFoldersScanning";


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
        _folders = @[];
        _sortDescriptors = @[
            [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
            [NSSortDescriptor sortDescriptorWithKey:@"fileSize" ascending:YES],
        ];
    }
    return self;
}


- (void)startScanningFolders:(NSArray<NSString *> *)folders;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LibraryWillStartScanningFoldersNotification
                                                        object:self];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        Stopwatch *stopwatch = [Stopwatch start];
        
        NSMutableOrderedSet<Book *> *books = [NSMutableOrderedSet new];
        for (NSString *folder in folders) {
            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:folder];
            NSString *relPath;
            while ((relPath = [enumerator nextObject])) {
                if (NSFileTypeRegular != enumerator.fileAttributes.fileType) continue;
                NSString *absPath = [folder stringByAppendingPathComponent:relPath];
                Book *book = [[Book alloc] initWithPath:absPath
                                      andFileAttributes:enumerator.fileAttributes];
                if (book) {
                    [books addObject:book];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [book startScanningFile];
                    });
                }
            }
        }
        [books sortUsingDescriptors:self->_sortDescriptors];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_books = books;
            self->_folders = [folders copy];
            
            self->_scanTime = [stopwatch stop];
            [[NSNotificationCenter defaultCenter] postNotificationName:LibraryDidFinishScanningFoldersNotification
                                                                object:self];
        });
    });
}


@end
