#import "Book.h"

#import "EPUB.h"
#import "PDF/PDF.h"


NSNotificationName const BookWillStartReadingFileNotification = @"BookWillStartReadingFile";
NSNotificationName const BookDidFinishReadingFileNotification = @"BookDidFinishReadingFile";


static BOOL
isOneWord(NSString *const string);

static NSString *
makeTitleFromFilename(NSString *path);


@interface Book ()

- (instancetype)initWithFormat:(enum Format)format
                          path:(NSString *)path
                   andFileSize:(NSNumber *)fileSize NS_DESIGNATED_INITIALIZER;

@end


@implementation Book
{
    NSString *_titleFromDocument;
    NSString *_titleFromFilename;
}


- (NSString *)title;
{
    return _titleFromFilename;
}


- (nullable instancetype)initWithPath:(NSString *)path
                          andFileSize:(NSNumber *)fileSize;
{
    if ([extensionForFormat(FormatEPUB) isEqualToString:path.pathExtension]) {
        return [self initWithFormat:FormatEPUB
                               path:path
                        andFileSize:fileSize];
    }
    if ([extensionForFormat(FormatPDF) isEqualToString:path.pathExtension]) {
        return [self initWithFormat:FormatPDF
                               path:path
                        andFileSize:fileSize];
    }
    return nil;
}


- (instancetype)initWithFormat:(enum Format)format
                          path:(NSString *)path
                   andFileSize:(NSNumber *)fileSize;
{
    self = [super init];
    if (self) {
        _fileSize = fileSize;
        _format = format;
        _pageCount = 0;
        _path = path;
        _titleFromDocument = nil;
        _titleFromFilename = makeTitleFromFilename(path);
        _wasRead = NO;
    }
    return self;
}


- (void)startReadingFile;
{
    NSAssert( ! self.wasRead, @"Expected book was not read yet.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BookWillStartReadingFileNotification
                                                        object:self];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        id<File> file = nil;
        switch (self->_format) {
            case FormatUnknown:
                file = nil;
                break;
            case FormatEPUB:
                file = [[EPUB alloc] initWithPath:self->_path];
                break;
            case FormatPDF:
                file = [[PDF alloc] initWithPath:self->_path];
                break;
            default:
                NSAssert(NO, @"Undefined Format %lu", self->_format);
                file = nil;
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_wasRead = YES;
            if (file) {
                self->_pageCount = file.pageCount;
                self->_titleFromDocument = file.title;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:BookDidFinishReadingFileNotification
                                                                object:self];
        });
    });
}


- (NSString *)description;
{
    return _titleFromFilename;
}


- (BOOL)isEqual:(id)object;
{
    if (self == object) return YES;
    if ( ! [object isKindOfClass:[Book class]]) return NO;
    Book *book = object;
    return [self.path isEqual:book->_path];
}


- (NSUInteger)hash;
{
    return _path.hash;
}


@end


BOOL
isOneWord(NSString *const string)
{
    NSRange range = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    return NSNotFound == range.location;
}


NSString *
makeTitleFromFilename(NSString *path)
{
    NSString *filename = path.lastPathComponent.stringByDeletingPathExtension;
    if (isOneWord(filename)) {
        if ([filename containsString:@"_"]) {
            return [filename stringByReplacingOccurrencesOfString:@"_"
                                                       withString:@" "];
        }
    }
    return filename;
}
