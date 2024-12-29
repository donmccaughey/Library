#import "EPUBRootfile.h"


@implementation EPUBRootfile


- (BOOL)isPackage;
{
    return [@"application/oebps-package+xml" isEqualToString:_mediaType];
}


- (instancetype)initWithMediaType:(NSString *)mediaType
                      andFullPath:(NSString *)fullPath;
{
    self = [super init];
    if ( ! self) return nil;
    
    _mediaType = [mediaType copy];
    _fullPath = [fullPath copy];
    
    return self;
}


@end
