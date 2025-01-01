#import <Foundation/Foundation.h>


@class EPUBRootfile;


NS_ASSUME_NONNULL_BEGIN


@interface EPUBContainer : NSObject<NSXMLParserDelegate>

@property (nullable, readonly) NSString *packagePath;
@property (readonly) NSArray<NSError *> *warnings;

- (instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithData:(NSData *)containerXml
                                error:(NSError **)error;

@end


NS_ASSUME_NONNULL_END
