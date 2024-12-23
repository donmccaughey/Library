#import "PDFMatcher.h"


static PDFMatcher *sharedInstance;


@implementation PDFMatcher


+ (void)initialize;
{
    sharedInstance = [PDFMatcher new];
}


+ (instancetype)matcher;
{
    return sharedInstance;
}


- (BOOL)pathMatches:(NSString *)path;
{
    return [@"pdf" isEqualToString:path.pathExtension];
}


@end
