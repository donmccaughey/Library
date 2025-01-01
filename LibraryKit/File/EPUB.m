#import "EPUB.h"

#import "EPUBContainer.h"
#import "Errors.h"
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
    
    Zip *zip = [[Zip alloc] initWithPath:path];
    if ( ! zip) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingEPUBZip
                                        andMessage:@"Unable to read EPUB zip file '%@'", path];
        }
        return nil;
    }
    
    NSString *containerPath = @"META-INF/container.xml";
    NSData *data = [zip dataForEntryWithPath:containerPath];
    if ( ! data) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingContainerXML
                                        andMessage:@"Unable to read '%@' entry in EPUB '%@'",
                      containerPath, path];
        }
        return nil;
    }
    
    NSError *containerError;
    EPUBContainer *container = [[EPUBContainer alloc] initWithData:data
                                                             error:&containerError];
    if ( ! container) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingContainerXML
                                   underlyingError:containerError
                                        andMessage:@"Unable to parse '%@' entry in EPUB '%@': %@",
                      containerPath, path, containerError.localizedDescription];
        }
        return nil;
    }
    if ( ! container.packagePath) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingContainerXML
                                        andMessage:@"No OPF package found in '%@' entry in EPUB '%@'",
                      containerPath, path];
        }
        return nil;
    }

    data = [zip dataForEntryWithPath:container.packagePath];
    if ( ! data) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                        andMessage:@"Unable to read '%@' entry in EPUB '%@'", container.packagePath, path];
        }
        return nil;
    }
    
    OPFPackage *package = [[OPFPackage alloc] initWithData:data];
    _title = [package.title copy];

    return self;
}


@end
