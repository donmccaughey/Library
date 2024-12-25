#import <Foundation/Foundation.h>


enum Format : NSUInteger {
    FormatUnknown = 0,
    FormatEPUB,
    FormatPDF,
};


NS_ASSUME_NONNULL_BEGIN


NSString *
extensionForFormat(enum Format format);


NSString *
formatName(enum Format format);


NS_ASSUME_NONNULL_END
