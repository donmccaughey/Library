#import <Foundation/Foundation.h>


enum BookType : NSUInteger {
    BookTypeUnknown = 0,
    BookTypeEPUB,
    BookTypePDF,
};


NS_ASSUME_NONNULL_BEGIN


NSString *
bookTypeExtension(enum BookType type);


NSString *
bookTypeName(enum BookType type);


NS_ASSUME_NONNULL_END
