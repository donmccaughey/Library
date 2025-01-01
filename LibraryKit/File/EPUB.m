#import "EPUB.h"

#import "EPUBContainer.h"
#import "OPFPackage.h"
#import "Zip.h"


@implementation EPUB


+ (Format)format;
{
    return FormatEPUB;
}


- (nullable instancetype)initWithPath:(NSString *)path
                                error:(NSError **)error;
{
    self = [super init];
    if ( ! self) return nil;
    
    _pageCount = 0;
    _title = nil;
    
    *error = nil;
    
    NSMutableArray<NSString *> *packagePaths = [NSMutableArray new];
    Zip *zip = [[Zip alloc] initWithPath:path];
    if ( ! zip) {
        NSLog(@"Unable to open zip archive for EPUB '%@'", path);
        return nil;
    }
    
    NSData *data = [zip dataForEntryWithPath:@"META-INF/container.xml"];
    if ( ! data) {
        NSLog(@"Unable to read 'container.xml' entry in EPUB '%@'", path);
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
        // fall back to searching for an .opf file
        NSArray<NSString *> *opfPaths = [zip entryPathsWithExtension:@"opf"];
        [packagePaths addObjectsFromArray:opfPaths];
    }
    
    if ( ! packagePaths.count) {
        NSLog(@"No package file found in EPUB '%@'", path);
        return nil;
    }
    
    if (packagePaths.count > 1) {
        NSLog(@"Found %lu package files in EPUB '%@'", (unsigned long)packagePaths.count, path);
    }
    
    NSString *packagePath = [packagePaths firstObject];
    NSLog(@"Reading package file '%@' for EPUB '%@'", packagePath, path.lastPathComponent);
    data = [zip dataForEntryWithPath:packagePath];
    if ( ! data) {
        NSLog(@"Unable to read '%@' entry in EPUB '%@'", packagePath, path);
        return nil;
    }
    
    OPFPackage *package = [[OPFPackage alloc] initWithData:data];
    _title = [package.title copy];

    return self;
}


@end
