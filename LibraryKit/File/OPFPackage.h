#import <Foundation/Foundation.h>


@class OPFIdentifier;


NS_ASSUME_NONNULL_BEGIN


@interface OPFPackage : NSObject<NSXMLParserDelegate>

@property (readonly) NSArray<NSString *> *titles;
@property (readonly) OPFIdentifier *uniqueIdentifier;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithData:(NSData *)containerXml
                       error:(NSError **)error;

@end


NS_ASSUME_NONNULL_END
