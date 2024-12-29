#import <Foundation/Foundation.h>


@protocol File;


enum Format : NSUInteger {
    FormatUnknown = 0,
    FormatEPUB,
    FormatPDF,
};


NS_ASSUME_NONNULL_BEGIN


NSString *
extensionForFormat(enum Format format);


Class<File>
fileClassForFormat(enum Format format);


enum Format
formatForExtension(NSString *extension);


NSString *
nameForFormat(enum Format format);


NS_ASSUME_NONNULL_END
