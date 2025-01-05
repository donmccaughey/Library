#import "OPFIdentifier.h"


@implementation OPFIdentifier


- (instancetype)initWithScheme:(NSString *)scheme
                 andIdentifier:(NSString *)identifier;
{
    self = [super init];
    if ( ! self) return nil;
    
    _identifier = [identifier copy];
    _scheme = [scheme copy];
    
    return self;
}


- (NSString *)description;
{
    if (_scheme) {
        return [NSString stringWithFormat:@"%@ %@", _scheme, _identifier];
    } else {
        return _identifier;
    }
}


@end
