#import "Book.h"


@interface Book (Internal)

@property (readwrite) BOOL isOpen;

- (instancetype)initWithType:(enum BookType)type
                        path:(NSString *)path
                 andFileSize:(NSNumber *)fileSize;

- (void)openOnGlobalQueue;

@end
