#import "PDF.h"

@import PDFKit;

#import "Errors.h"


@implementation PDF


+ (Format)format;
{
    return FormatPDF;
}


- (nullable instancetype)initWithPath:(NSString *)path
                                error:(NSError **)error;
{
    self = [super init];
    if ( ! self) return nil;
    
    NSURL *url = [NSURL fileURLWithPath:path];
    PDFDocument *document = [[PDFDocument alloc] initWithURL:url];
    if ( ! document) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingPDF
                                        andMessage:@"Unable to read PDF file at '%@'", path];
        }
        return nil;
    }
    
    _pageCount = document.pageCount;
    _title = [document.documentAttributes[PDFDocumentTitleAttribute] copy];

    return self;
}


@end
