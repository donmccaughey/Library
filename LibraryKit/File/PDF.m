#import "PDF.h"

@import PDFKit;


@implementation PDF


+ (enum Format)format;
{
    return FormatPDF;
}


- (nullable instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if ( ! self) return nil;
    
    NSURL *url = [NSURL fileURLWithPath:path];
    PDFDocument *document = [[PDFDocument alloc] initWithURL:url];
    if ( ! document) {
        NSLog(@"Failed to open PDF file at '%@'", path);
        return nil;
    }
    
    NSLog(@"Reading data from PDF '%@'", path.lastPathComponent);
    _pageCount = document.pageCount;
    _title = document.documentAttributes[PDFDocumentTitleAttribute];

    return self;
}


@end
