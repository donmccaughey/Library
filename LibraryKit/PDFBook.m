#import "PDFBook.h"

#import "Book-internal.h"


@interface PDFBook ()

- (instancetype)initWithType:(enum BookType)type
                    typeName:(NSString *)typeName
                        path:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;

@end


@implementation PDFBook


- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    return [super initWithType:BookTypePDF
                      typeName:@"PDF"
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


@end
