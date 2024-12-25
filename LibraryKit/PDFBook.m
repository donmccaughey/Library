#import "PDFBook.h"

@import PDFKit;

#import "Book+Internal.h"


@implementation PDFBook
{
    PDFDocument *_document;
}


- (NSUInteger)pageCount;
{
    return _document.pageCount;
}


- (instancetype)initWithPath:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;
{
    return [self initWithType:BookTypePDF
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


- (void)openOnGlobalQueue;
{
    [super openOnGlobalQueue];
    NSURL *url = [NSURL fileURLWithPath:self.path];
    _document = [[PDFDocument alloc] initWithURL:url];
    if ( ! _document) {
        NSLog(@"Failed to open PDF document at '%@'", self.path);
    }
}


- (void)close;
{
    _document = nil;
    [super close];
}


@end
