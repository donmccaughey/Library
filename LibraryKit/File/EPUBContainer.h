#import <Foundation/Foundation.h>

#import "XML.h"


@class EPUBRootfile;


NS_ASSUME_NONNULL_BEGIN


@interface EPUBContainer : XML

@property (nullable, readonly) NSString *packagePath;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithData:(NSData *)containerXML
                                error:(NSError **)error;

@end


NS_ASSUME_NONNULL_END
