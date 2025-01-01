#import "PDF.h"

@import PDFKit;

#import "Error.h"


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
        NSString *message = [NSString stringWithFormat:@"Unable to read PDF file at '%@'", path];
        NSLog(@"%@", message);
        if (error) {
            *error = [NSError errorWithDomain:LibraryErrorDomain
                                         code:LibraryErrorReadingPDF
                                     userInfo:@{ NSLocalizedDescriptionKey: message }];
        }
        return nil;
    }
    
    _pageCount = document.pageCount;
    _title = [document.documentAttributes[PDFDocumentTitleAttribute] copy];

    return self;
}


@end
