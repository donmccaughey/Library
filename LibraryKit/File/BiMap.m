#import "BiMap.h"


@implementation BiMap
{
    NSMutableDictionary *_firstToSecond;
    NSMutableDictionary *_secondToFirst;
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _firstToSecond = [NSMutableDictionary new];
    _secondToFirst = [NSMutableDictionary new];
    
    return self;
}


- (nullable id)firstForSecond:(id)second;
{
    return _secondToFirst[second];
}


- (nullable id)secondForFirst:(id)first;
{
    return _firstToSecond[first];
}


- (void)setFirst:(id)first forSecond:(id)second;
{
    [self removeFirst:first];
    [self removeSecond:second];
    
    _firstToSecond[first] = second;
    _secondToFirst[second] = first;
}


- (void)removeFirst:(id)first;
{
    id second = _firstToSecond[first];
    if ( ! second) return;
    
    [_firstToSecond removeObjectForKey:first];
    [_secondToFirst removeObjectForKey:second];
}


- (void)removeSecond:(id)second;
{
    id first = _secondToFirst[second];
    if ( ! first) return;
    
    [_secondToFirst removeObjectForKey:second];
    [_firstToSecond removeObjectForKey:first];
}


@end
