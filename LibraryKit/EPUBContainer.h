#import <Foundation/Foundation.h>


@class EPUBRootfile;


NS_ASSUME_NONNULL_BEGIN


@interface EPUBContainer : NSObject <NSXMLParserDelegate>

@property (nullable, readonly, copy) NSString *firstPackagePath;
@property (readonly, copy) NSArray<EPUBRootfile *> *rootfiles;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithData:(NSData *)containerXml;

@end


NS_ASSUME_NONNULL_END
