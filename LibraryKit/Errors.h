#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LibraryError) {
    LibraryErrorNone = 0,
    LibraryErrorReadingContainerXML,
    LibraryErrorReadingEPUBZip,
    LibraryErrorReadingPDF,
};


extern NSErrorDomain LibraryErrorDomain;


@interface NSError (Library)

+ (instancetype)libraryErrorWithCode:(NSInteger)code
                          andMessage:(NSString *)format, ...;

@end
