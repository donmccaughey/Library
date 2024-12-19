#import "PDFFileMatcher.h"


@implementation PDFFileMatcher


- (BOOL)pathMatches:(NSString *)path;
{
    return [@"pdf" isEqualToString:path.pathExtension];
}


@end
