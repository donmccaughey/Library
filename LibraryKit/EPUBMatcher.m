#import "EPUBMatcher.h"


static EPUBMatcher *sharedInstance;


@implementation EPUBMatcher


+ (void)initialize;
{
    sharedInstance = [EPUBMatcher new];
}


+ (instancetype)matcher;
{
    return sharedInstance;
}


- (BOOL)pathMatches:(NSString *)path;
{
    return [@"epub" isEqualToString:path.pathExtension];
}

@end
