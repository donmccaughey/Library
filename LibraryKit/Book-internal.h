#import "Book.h"


@interface Book (Internal)

@property (readwrite) BOOL isOpen;

- (instancetype)initWithType:(enum BookType)type
                    typeName:(NSString *)typeName
                        path:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;

@end
