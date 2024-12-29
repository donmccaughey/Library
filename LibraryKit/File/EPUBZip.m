#import "EPUBZip.h"

@import minizip;


@implementation EPUBZip


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
