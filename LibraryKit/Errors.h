#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LibraryError) {
    LibraryErrorNone = 0,
    LibraryErrorReadingEPUBZip = 2,
    LibraryErrorMissingContainerXML = 3,
    LibraryErrorReadingPDF = 4,
};


extern NSErrorDomain LibraryErrorDomain;


@interface NSError (Library)

+ (instancetype)libraryErrorWithCode:(NSInteger)code
                          andMessage:(NSString *)format, ...;

@end
