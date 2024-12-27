#import "EPUB.h"

#import <minizip/minizip.h>


BOOL
endsWith(char const *s, char const *suffix);


@implementation EPUB


- (instancetype)init;
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (nullable instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if ( ! self) return nil;
    
    _pageCount = 0;
    _title = nil;
    
    int32_t error;
    void *zipReader = mz_zip_reader_create();
    error = mz_zip_reader_open_file(zipReader, path.UTF8String);
    if (error) {
        NSLog(@"Failed to open EPUB at '%@'", path);
        mz_zip_reader_delete(&zipReader);
        return self;
    }
    
    mz_zip_file *zipFile;
    error = mz_zip_reader_goto_first_entry(zipReader);
    while ( ! error) {
        error = mz_zip_reader_entry_get_info(zipReader, &zipFile);
        if (error) {
            NSLog(@"Failed to read entry from EPUB at '%@'", path);
        } else {
            if (0 == strcasecmp("META-INF/container.xml", zipFile->filename)) {
                NSLog(@"Found 'container.xml' in EPUB '%@'", path.lastPathComponent);
                // TODO: parse container.xml to find root files with mimetype application/oebps-package+xml
                // TODO: fall back to searching for a .opf file if this fails
            } else if (endsWith(zipFile->filename, ".opf")) {
                NSLog(@"Found '%s' in EPUB '%@'", zipFile->filename, path.lastPathComponent);
            }
            error = mz_zip_reader_goto_next_entry(zipReader);
        }
    }
    if (MZ_END_OF_LIST != error) {
        NSLog(@"Error reading entries from EPUB at '%@': %d", path, error);
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
