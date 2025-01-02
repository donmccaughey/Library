#import "Stopwatch.h"

#import "ElapsedTime.h"


static double const NANOS_PER_SEC = 1e9;


@implementation Stopwatch
{
    struct timespec _startTime;
}


+ (instancetype)start;
{
    return [self new];
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    clock_gettime(CLOCK_UPTIME_RAW, &_startTime);
    
    return self;
}


- (ElapsedTime *)stop;
{
    struct timespec stopTime;
    clock_gettime(CLOCK_UPTIME_RAW, &stopTime);
    
    struct timespec difference;
    if (stopTime.tv_nsec < _startTime.tv_nsec) {
        difference.tv_sec = stopTime.tv_sec - _startTime.tv_sec - 1;
        difference.tv_nsec = NANOS_PER_SEC + stopTime.tv_nsec - _startTime.tv_nsec;
    } else {
        difference.tv_sec = stopTime.tv_sec - _startTime.tv_sec;
        difference.tv_nsec = stopTime.tv_nsec - _startTime.tv_nsec;
    }
    
    NSTimeInterval seconds = difference.tv_sec + (difference.tv_nsec / NANOS_PER_SEC);
    return [ElapsedTime elapsedTimeWithSeconds:seconds];
}


@end
