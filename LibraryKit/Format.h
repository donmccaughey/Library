#import <Foundation/Foundation.h>


@protocol File;


typedef NS_ENUM(NSInteger, Format) {
    FormatUnknown = 0,
    FormatEPUB,
    FormatPDF,
};


NS_ASSUME_NONNULL_BEGIN


NSString *
extensionForFormat(Format format);


Class<File>
fileClassForFormat(Format format);


Format
formatForExtension(NSString *extension);


NSString *
nameForFormat(Format format);


NS_ASSUME_NONNULL_END
