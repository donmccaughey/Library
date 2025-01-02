#import "Timing.h"


double const MILLIS_PER_SEC = 1e3;
double const MICROS_PER_SEC = 1e6;

double const NANOS_PER_SEC = 1e9;
double const NANOS_PER_MILLI = 1e6;
double const NANOS_PER_MICRO = 1e3;


struct timespec
calculateDuration(struct timespec start, struct timespec end)
{
    struct timespec duration;
    if (end.tv_nsec < start.tv_nsec) {
        duration.tv_sec = end.tv_sec - start.tv_sec - 1;
        duration.tv_nsec = 1000000000 + end.tv_nsec - start.tv_nsec;
    } else {
        duration.tv_sec = end.tv_sec - start.tv_sec;
        duration.tv_nsec = end.tv_nsec - start.tv_nsec;
    }
    return duration;
}


struct timespec
calculateDurationFrom(struct timespec start)
{
    struct timespec timeNow;
    clock_gettime(CLOCK_UPTIME_RAW, &timeNow);
    return calculateDuration(start, timeNow);
}


NSTimeInterval
calculateTimeIntervalFrom(struct timespec start)
{
    return timespecToTimeInterval(calculateDurationFrom(start));
}


NSString *
formatDuration(struct timespec duration)
{
   if (duration.tv_sec > 0) {
       double seconds = duration.tv_sec + duration.tv_nsec / NANOS_PER_SEC;
       return [NSString stringWithFormat:@"%.1f s", seconds];
   } else if (duration.tv_nsec >= 1000000) {
       double milliseconds = duration.tv_nsec / NANOS_PER_MILLI;
       return [NSString stringWithFormat:@"%.1f ms", milliseconds];
   } else {
       double microseconds = duration.tv_nsec / NANOS_PER_MICRO;
       return [NSString stringWithFormat:@"%.1f µs", microseconds];
   }
}


NSString *
formatTimeInterval(NSTimeInterval interval)
{
    if (interval >= 1.0) {
        return [NSString stringWithFormat:@"%.1f s", interval];
    } else if (interval >= 0.001) {
        return [NSString stringWithFormat:@"%.1f ms", interval * MILLIS_PER_SEC];
    } else {
        return [NSString stringWithFormat:@"%.1f µs", interval * MICROS_PER_SEC];
    }
}


NSTimeInterval
timespecToTimeInterval(struct timespec spec)
{
    return (NSTimeInterval)spec.tv_sec + (spec.tv_nsec / NANOS_PER_SEC);
}
