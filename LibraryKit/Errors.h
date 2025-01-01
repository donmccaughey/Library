#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LibraryError) {
    LibraryErrorNone = 0,
    LibraryErrorReadingContainerXML,
    LibraryErrorReadingEPUBZip,
    LibraryErrorReadingOPFPackageXML,
    LibraryErrorReadingPDF,
};


NS_ASSUME_NONNULL_BEGIN


extern NSErrorDomain LibraryErrorDomain;


@interface NSError (Library)

+ (instancetype)libraryErrorWithCode:(NSInteger)code
                          andMessage:(NSString *)format, ...;

+ (instancetype)libraryErrorWithCode:(NSInteger)code
                     underlyingError:(nullable NSError *)underlyingError
                          andMessage:(NSString *)format, ...;

@end


NS_ASSUME_NONNULL_END
