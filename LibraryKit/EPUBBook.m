#import "EPUBBook.h"

#import "Book+Internal.h"


@implementation EPUBBook


- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    return [self initWithType:BookTypeEPUB
                     typeName:@"EPUB"
                          path:path
                   andFileSize:fileSize];
}


- (instancetype)initWithType:(enum BookType)type
                    typeName:(NSString *)typeName
                        path:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    self = [super initWithType:type
                      typeName:typeName
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
