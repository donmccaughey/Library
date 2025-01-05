#import <Foundation/Foundation.h>

#import "XML.h"


@class OPFIdentifier;


NS_ASSUME_NONNULL_BEGIN


@interface OPFPackage : XML

@property (readonly) NSArray<NSString *> *titles;
@property (readonly) OPFIdentifier *uniqueIdentifier;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithData:(NSData *)packageXML
                                error:(NSError **)error;

@end


NS_ASSUME_NONNULL_END
