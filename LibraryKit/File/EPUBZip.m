#import "EPUBZip.h"

@import minizip;


@implementation EPUBZip


- (nullable NSData *)dataForEntryWithPath:(NSString *)entryPath;
{
    BOOL ignoreCase = YES;
    int32_t error = mz_zip_reader_locate_entry(_reader, entryPath.UTF8String, ignoreCase);
    if (error) {
        NSLog(@"Entry '%@' not found in zip file '%@'", entryPath, _path);
        return nil;
    }
    
    mz_zip_file *fileInfo;
    error = mz_zip_reader_entry_get_info(_reader, &fileInfo);
    if (error) {
        NSLog(@"Could not get info for entry '%@' in zip file '%@'", entryPath, _path);
        mz_zip_reader_entry_close(_reader);
        return nil;
    }
    
    error = mz_zip_reader_entry_open(_reader);
    if (error) {
        NSLog(@"Could not open entry '%@' in zip file '%@'", entryPath, _path);
        mz_zip_reader_entry_close(_reader);
        return nil;
    }
    
    NSAssert(fileInfo->uncompressed_size < INT32_MAX,
             @"Entry '%@' in zip file '%@' has unusually large size %lld bytes",
             entryPath, _path, fileInfo->uncompressed_size);
    NSUInteger entrySize = (fileInfo->uncompressed_size < INT32_MAX)
            ? fileInfo->uncompressed_size
            : INT32_MAX;
    NSMutableData *data = [NSMutableData dataWithLength:entrySize];
    int32_t bytesRead = mz_zip_reader_entry_read(_reader, data.mutableBytes, (int32_t)data.length);
    if (bytesRead != fileInfo->uncompressed_size) {
        NSLog(@"Only read %d of %lld bytes for entry '%@' in zip file '%@'",
              bytesRead, fileInfo->uncompressed_size, entryPath, _path);
        mz_zip_reader_entry_close(_reader);
        return nil;
    }
    
    mz_zip_reader_entry_close(_reader);
    return data;
}


- (NSArray<NSString *> *)entryPathsMatchingPredicate:(NSPredicate *)predicate;
{
    NSMutableArray<NSString *> *entryPaths = [NSMutableArray new];
    
    int32_t error = mz_zip_reader_goto_first_entry(_reader);
    mz_zip_file *fileInfo;
    while ( ! error) {
        error = mz_zip_reader_entry_get_info(_reader, &fileInfo);
        if (error) {
            NSLog(@"Failed to read entry from zip file '%@'", _path);
            return entryPaths;
        }
        
        NSString *entryPath = [NSString stringWithUTF8String:fileInfo->filename];
        if ([predicate evaluateWithObject:entryPath]) {
            [entryPaths addObject:entryPath];
        }
        error = mz_zip_reader_goto_next_entry(_reader);
    }
    
    if (error != MZ_END_OF_LIST) {
        NSLog(@"Error reading entries from zip file '%@': %d", _path, error);
    }

    return entryPaths;
}


- (NSArray<NSString *> *)entryPathsWithExtension:(NSString *)extension;
{
    NSString *dotExtension = [@"." stringByAppendingString:extension];
    NSPredicate *hasExtension = [NSPredicate predicateWithFormat:@"self ENDSWITH[c] %@", dotExtension];
    return [self entryPathsMatchingPredicate:hasExtension];
}


- (nullable instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if ( ! self) return nil;
    
    _path = path;
    
    _reader = mz_zip_reader_create();
    int32_t error = mz_zip_reader_open_file(_reader, _path.UTF8String);
    if (error) {
        NSLog(@"Failed to open EPUB at '%@'", _path);
        mz_zip_reader_delete(&_reader);
        return nil;
    }

    return self;
}


- (void)dealloc;
{
    mz_zip_reader_close(_reader);
    mz_zip_reader_delete(&_reader);
}


@end
