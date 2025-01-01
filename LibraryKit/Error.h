#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LibraryError) {
    LibraryErrorNone = 0,
    LibraryErrorReadingPDF = 1,
};


extern NSErrorDomain LibraryErrorDomain;
