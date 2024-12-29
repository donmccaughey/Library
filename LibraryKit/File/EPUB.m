#import "EPUB.h"

#import "EPUBContainer.h"
#import "EPUBZip.h"


@implementation EPUB


+ (enum Format)format;
{
    return FormatEPUB;
}


- (nullable instancetype)initWithPath:(NSString *)path;
{
    self = [super init];
    if ( ! self) return nil;
    
    _pageCount = 0;
    _title = nil;
    
    NSMutableArray<NSString *> *packagePaths = [NSMutableArray new];
    EPUBZip *zip = [[EPUBZip alloc] initWithPath:path];
    if ( ! zip) {
        NSLog(@"Unable to open zip archive for EPUB '%@'", path);
        return nil;
    }
    
    NSData *data = [zip dataForEntryWithPath:@"META-INF/container.xml"];
    if ( ! data) {
        NSLog(@"Unable to read 'container.xml' file for EPUB '%@'", path);
    }
    
    if (data) {
        EPUBContainer *container = [[EPUBContainer alloc] initWithData:data];
        NSLog(@"Found %lu rootfiles in 'container.xml' in EPUB '%@'",
              (unsigned long)container.rootfiles.count, path.lastPathComponent);
        NSString *packagePath = container.firstPackagePath;
        if (packagePath) {
            NSLog(@"Found first package at '%@' in 'container.xml' in EPUB '%@'", packagePath, path.lastPathComponent);
            [packagePaths addObject:packagePath];
        } else {
            NSLog(@"No package found in 'container.xml' in EPUB '%@'", path.lastPathComponent);
        }
    }
       
    if ( ! packagePaths.count) {
        // TODO: fall back to searching for an .opf file
        NSArray<NSString *> *opfPaths = [zip entryPathsWithExtension:@"opf"];
        [packagePaths addObjectsFromArray:opfPaths];
    }
    
    if ( ! packagePaths.count) {
        NSLog(@"No package file found in EPUB '%@'", path);
        return nil;
    }
    
    NSString *packagePath = [packagePaths firstObject];
    NSLog(@"Reading package file '%@' for EPUB '%@'", packagePath, path.lastPathComponent);
    // TODO: read the first package file

    return self;
}


@end
