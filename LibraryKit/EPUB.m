#import "EPUB.h"

#import <minizip/minizip.h>

#import "EPUBContainer.h"


BOOL
endsWith(char const *s, char const *suffix);


@implementation EPUB


- (nullable instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if ( ! self) return nil;
    
    _pageCount = 0;
    _title = nil;
    
    NSMutableArray<NSString *> *packagePaths = [NSMutableArray new];
    
    int32_t error;
    void *zipReader = mz_zip_reader_create();
    error = mz_zip_reader_open_file(zipReader, path.UTF8String);
    if (error) {
        NSLog(@"Failed to open EPUB at '%@'", path);
        mz_zip_reader_delete(&zipReader);
        return self;
    }
    
    BOOL ignoreCase = YES;
    error = mz_zip_reader_locate_entry(zipReader, "META-INF/container.xml", ignoreCase);
    if ( ! error) {
        mz_zip_file *fileInfo;
        error = mz_zip_reader_entry_get_info(zipReader, &fileInfo);
        if ( ! error) {
            error = mz_zip_reader_entry_open(zipReader);
            if ( ! error) {
                NSMutableData *data = [NSMutableData dataWithLength:fileInfo->uncompressed_size];
                int32_t bytesRead = mz_zip_reader_entry_read(zipReader, data.mutableBytes, (int32_t)data.length);
                if (bytesRead == fileInfo->uncompressed_size) {
                    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data];
                    NSLog(@"Found %lu rootfiles in 'container.xml' in EPUB '%@'",
                          (unsigned long)container.rootfiles.count, path.lastPathComponent);
                    NSString *packagePath = container.firstPackagePath;
                    if (packagePath) {
                        NSLog(@"Found first package at '%@' in 'container.xml' in EPUB '%@'", packagePath, path.lastPathComponent);
                        [packagePaths addObject:packagePath];
                    } else {
                        NSLog(@"No package found in 'container.xml' in EPUB '%@'", path.lastPathComponent);
                    }
                } else {
                    NSLog(@"Only read %d of %lld bytes of 'container.xml' in EPUB '%@'",
                          bytesRead, fileInfo->uncompressed_size, path);
                }
                mz_zip_reader_entry_close(zipReader);
            }
        }
    }
    
    if ( ! packagePaths.count) {
        // TODO: fall back to searching for a .opf file
        NSLog(@"Did not find 'container.xml' for EPUB at '%@'", path);
        error = mz_zip_reader_goto_first_entry(zipReader);
        mz_zip_file *fileInfo;
        while ( ! error) {
            error = mz_zip_reader_entry_get_info(zipReader, &fileInfo);
            if (error) {
                NSLog(@"Failed to read entry from EPUB at '%@'", path);
            } else {
                if (endsWith(fileInfo->filename, ".opf")) {
                    // TODO: is utf-8 encoding a valid assumption?
                    NSString *packagePath = [NSString stringWithUTF8String:fileInfo->filename];
                    NSLog(@"Found package at '%@' in EPUB '%@'", packagePath, path.lastPathComponent);
                    [packagePaths addObject:packagePath];
                }
                error = mz_zip_reader_goto_next_entry(zipReader);
            }
        }
        if (MZ_END_OF_LIST != error) {
            NSLog(@"Error reading entries from EPUB at '%@': %d", path, error);
        }
    }
    
    if (packagePaths.count) {
        // TODO: read the first package file
        NSString *packagePath = [packagePaths firstObject];
        NSLog(@"Reading package file '%@' for EPUB '%@'", packagePath, path.lastPathComponent);
    }
    
    mz_zip_reader_close(zipReader);
    mz_zip_reader_delete(&zipReader);
    
    return self;
}


@end


BOOL
endsWith(char const *s, char const *suffix)
{
    size_t suffix_len = strlen(suffix);
    char const *suffix_start = strstr(s, suffix);
    return suffix_start && ! suffix_start[suffix_len];
}
