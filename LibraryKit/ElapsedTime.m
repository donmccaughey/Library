#import "ElapsedTime.h"


static double const MILLIS_PER_SEC = 1e3;
static double const MICROS_PER_SEC = 1e6;
static double const ONE_MILLI_SEC = 1e-3;


@implementation ElapsedTime


+ (instancetype)elapsedTimeWithSeconds:(NSTimeInterval)seconds;
{
    return [[self alloc] initWithSeconds:seconds];
}


- (instancetype)initWithSeconds:(NSTimeInterval)seconds;
{
    self = [super init];
    if ( ! self) return nil;
    
    _seconds = seconds;
    
    return self;
}


- (NSString *)description;
{
    NSAssert(ONE_MILLI_SEC == 0.001, @"Checking constant value");
    
    if (_seconds >= 1.0) {
        return [NSString stringWithFormat:@"%.1f s", _seconds];
    } else if (_seconds >= ONE_MILLI_SEC) {
        return [NSString stringWithFormat:@"%.1f ms", _seconds * MILLIS_PER_SEC];
    } else {
        return [NSString stringWithFormat:@"%.1f µs", _seconds * MICROS_PER_SEC];
    }
}


@end
