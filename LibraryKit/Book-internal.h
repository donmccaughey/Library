#import "Book.h"


@interface Book (Internal)

- (instancetype)initWithType:(enum BookType)type
                    typeName:(NSString *)typeName
                        path:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;

@end
