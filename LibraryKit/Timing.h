#import <Foundation/Foundation.h>


extern double const MILLIS_PER_SEC;
extern double const MICROS_PER_SEC;

extern double const NANOS_PER_SEC;
extern double const NANOS_PER_MILLI;
extern double const NANOS_PER_MICRO;


struct timespec
calculateDuration(struct timespec start, struct timespec end);

struct timespec
calculateDurationFrom(struct timespec start);

NSTimeInterval
calculateTimeIntervalFrom(struct timespec start);

NSString *
formatDuration(struct timespec duration);

NSString *
formatTimeInterval(NSTimeInterval interval);

NSTimeInterval
timespecToTimeInterval(struct timespec spec);
