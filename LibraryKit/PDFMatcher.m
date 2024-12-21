#import "PDFMatcher.h"


@implementation PDFMatcher


- (BOOL)pathMatches:(NSString *)path;
{
    return [@"pdf" isEqualToString:path.pathExtension];
}


@end
