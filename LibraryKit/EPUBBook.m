#import "EPUBBook.h"

#import "Book+Internal.h"


@implementation EPUBBook


- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    return [self initWithType:BookTypeEPUB
                          path:path
                   andFileSize:fileSize];
}


- (instancetype)initWithType:(enum BookType)type
                        path:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    self = [super initWithType:type
                          path:path
                   andFileSize:fileSize];
    if ( ! self) return nil;
    
    return self;
}


- (void)openOnGlobalQueue;
{
    [super openOnGlobalQueue];
    // TODO: open epub
}


- (void)close;
{
    [super close];
}


@end
