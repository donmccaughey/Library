#import "PDF.h"

@import PDFKit;


@implementation PDF


- (instancetype)init;
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if ( ! self) return nil;
    
    NSURL *url = [NSURL fileURLWithPath:path];
    PDFDocument *document = [[PDFDocument alloc] initWithURL:url];
    if ( ! document) {
        NSLog(@"Failed to open PDF file at '%@'", path);
    }
    _pageCount = document.pageCount;
    _title = document.documentAttributes[PDFDocumentTitleAttribute];

    return self;
}


@end
