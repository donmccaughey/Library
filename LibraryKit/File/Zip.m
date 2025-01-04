#import "Zip.h"

@import minizip;


NSErrorDomain ZipErrorDomain = @"ZipError";


@implementation NSError (Library)


+ (instancetype)zipErrorWithCode:(NSInteger)code
                      andMessage:(NSString *)format, ...;
{
    va_list arguments;
    va_start(arguments, format);
    NSString *message = [[NSString alloc] initWithFormat:format
                                               arguments:arguments];
    va_end(arguments);
    NSLog(@"%@", message);
    return [self errorWithDomain:ZipErrorDomain
                            code:code
                        userInfo:@{ NSLocalizedDescriptionKey: message }];
}


@end


@interface Zip ()

- (BOOL)getFileInfoForFirstEntry:(mz_zip_file **)fileInfo
                           error:(NSError **)error;

@end


@implementation Zip
{
    void *_reader;
}


- (nullable instancetype)initWithPath:(NSString *)path
                                error:(NSError **)error;
{
    self = [super init];
    if ( ! self) return nil;
    
    _path = [path copy];
    
    // TODO: check file signature

    _reader = mz_zip_reader_create();
    int32_t err = mz_zip_reader_open_file(_reader, _path.UTF8String);
    if (err) {
        if (error) {
            *error = [NSError zipErrorWithCode:err
                                    andMessage:@"Failed to open zip file at '%@'", _path];
        }
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


- (nullable NSData *)dataForEntryWithPath:(NSString *)entryPath
                                    error:(NSError **)error;
{
    BOOL ignoreCase = YES;
    int32_t err = mz_zip_reader_locate_entry(_reader, entryPath.UTF8String, ignoreCase);
    if (err) {
        if (error) {
            *error = [NSError zipErrorWithCode:err
                                    andMessage:@"Entry '%@' not found in zip file '%@'", entryPath, _path];
        }
        return nil;
    }
    
    mz_zip_file *fileInfo;
    err = mz_zip_reader_entry_get_info(_reader, &fileInfo);
    if (err) {
        if (error) {
            *error = [NSError zipErrorWithCode:err
                                    andMessage:@"Could not get info for entry '%@' in zip file '%@'", entryPath, _path];
        }
        return nil;
    }
    
    err = mz_zip_reader_entry_open(_reader);
    if (err) {
        if (error) {
            *error = [NSError zipErrorWithCode:err
                                    andMessage:@"Could not open entry '%@' in zip file '%@'", entryPath, _path];
        }
        return nil;
    }
    
    if (fileInfo->uncompressed_size > INT32_MAX) {
        if (error) {
            NSString *byteCount = [NSByteCountFormatter stringFromByteCount:fileInfo->uncompressed_size
                                                                 countStyle:NSByteCountFormatterCountStyleFile];
            *error = [NSError zipErrorWithCode:MZ_INTERNAL_ERROR
                                    andMessage:@"Entry '%@' in zip file '%@' has unusually large size of %@",
                      entryPath, _path, byteCount];
        }
        return nil;
    }
    
    NSMutableData *data = [NSMutableData dataWithLength:fileInfo->uncompressed_size];
    int32_t bytesRead = mz_zip_reader_entry_read(_reader, data.mutableBytes, (int32_t)data.length);
    if (bytesRead != fileInfo->uncompressed_size) {
        if (error) {
            if (bytesRead < 0) {
                int32_t err = bytesRead;
                *error = [NSError zipErrorWithCode:err
                                        andMessage:@"Could not read entry '%@' in zip file '%@'", entryPath, _path];
            } else {
                *error = [NSError zipErrorWithCode:MZ_READ_ERROR
                                        andMessage:@"Only read %d of %lld bytes for entry '%@' in zip file '%@'",
                          bytesRead, fileInfo->uncompressed_size, entryPath, _path];
            }
        }
        return nil;
    }
    
    return data;
}


- (BOOL)getFileInfoForFirstEntry:(mz_zip_file **)fileInfo
                           error:(NSError **)error;
{
    int32_t err = mz_zip_reader_goto_first_entry(_reader);
    if (err) {
        if (error) {
            *error = [NSError zipErrorWithCode:err
                                  andMessage:@"Could not go to first entry in zip file '%@'", _path];
        }
        return NO;
    }
    
    err = mz_zip_reader_entry_get_info(_reader, fileInfo);
    if (err) {
        if (error) {
            *error = [NSError zipErrorWithCode:err
                                    andMessage:@"Could not get info for first entry in zip file '%@'", _path];
        }
        return NO;
    }

    return YES;
}


- (nullable NSString *)pathOfFirstEntryWithError:(NSError **)error;
{
    mz_zip_file *fileInfo;
    BOOL success = [self getFileInfoForFirstEntry:&fileInfo
                                            error:error];
    return success ? @(fileInfo->filename) : nil;
}


@end
