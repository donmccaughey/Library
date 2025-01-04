#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface OPFPackage : NSObject<NSXMLParserDelegate>

@property (readonly) NSString *title;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithData:(NSData *)containerXml
                       error:(NSError **)error;

@end


NS_ASSUME_NONNULL_END
