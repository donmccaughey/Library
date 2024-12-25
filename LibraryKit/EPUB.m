#import "EPUB.h"


@implementation EPUB


- (instancetype)init;
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (nullable instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if ( ! self) return nil;
    
    _pageCount = 0;
    _title = nil;
    
    return self;
}


@end
