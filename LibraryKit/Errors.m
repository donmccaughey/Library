#import "Errors.h"

#import <stdarg.h>


NSErrorDomain LibraryErrorDomain = @"LibraryError";


@implementation NSError (Library)


+ (instancetype)libraryErrorWithCode:(NSInteger)code
                          andMessage:(NSString *)format, ...;
{
    va_list arguments;
    va_start(arguments, format);
    NSString *message = [[NSString alloc] initWithFormat:format
                                               arguments:arguments];
    va_end(arguments);
    NSLog(@"%@", message);
    return [self errorWithDomain:LibraryErrorDomain
                            code:code
                        userInfo:@{ NSLocalizedDescriptionKey: message }];
}


+ (instancetype)libraryErrorWithCode:(NSInteger)code
                     underlyingError:(nullable NSError *)underlyingError
                          andMessage:(NSString *)format, ...;
{
    va_list arguments;
    va_start(arguments, format);
    NSString *message = [[NSString alloc] initWithFormat:format
                                               arguments:arguments];
    va_end(arguments);
    
    NSLog(@"%@", message);
    
    NSMutableDictionary<NSErrorUserInfoKey, id> *userInfo = [NSMutableDictionary new];
    userInfo[NSLocalizedDescriptionKey] = message;
    if (underlyingError) userInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [self errorWithDomain:LibraryErrorDomain
                            code:code
                        userInfo:userInfo];
}


@end
