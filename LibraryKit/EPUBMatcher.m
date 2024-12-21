#import "EPUBMatcher.h"


@implementation EPUBMatcher


- (BOOL)pathMatches:(NSString *)path;
{
    return [@"epub" isEqualToString:path.pathExtension];
}

@end
