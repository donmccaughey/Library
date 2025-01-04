#import "OPFIdentifier.h"


@implementation OPFIdentifier


- (instancetype)initWithID:(nullable NSString *)ID
                 andScheme:(nullable NSString *)scheme;
{
    self = [super init];
    if ( ! self) return nil;
    
    _ID = [ID copy];
    _scheme = [scheme copy];
    
    return self;
}


- (NSString *)description;
{
    if (_ID && _scheme) {
        return [NSString stringWithFormat:@"%@ = %@ [id=%@]", _scheme, _identifier, _ID];
    } else if (_ID) {
        return [NSString stringWithFormat:@"%@ [id=%@]", _identifier, _ID];
    } else if (_scheme) {
        return [NSString stringWithFormat:@"%@ = %@", _scheme, _identifier];
    } else {
        return _identifier;
    }
}


@end
