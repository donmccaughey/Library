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
    
    NSError *zipError;
    Zip *zip = [[Zip alloc] initWithPath:path
                                   error:&zipError];
    if ( ! zip) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingEPUBZip
                                   underlyingError:zipError
                                        andMessage:@"Unable to read EPUB file '%@'", path];
        }
        return nil;
    }
    
    NSString *containerPath = @"META-INF/container.xml";
    NSData *data = [zip dataForEntryWithPath:containerPath
                                       error:&zipError];
    if ( ! data) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingContainerXML
                                   underlyingError:zipError
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

    data = [zip dataForEntryWithPath:container.packagePath
                               error:&zipError];
    if ( ! data) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                   underlyingError:zipError
                                        andMessage:@"Unable to read '%@' entry in EPUB '%@'", container.packagePath, path];
        }
        return nil;
    }
    
    OPFPackage *package = [[OPFPackage alloc] initWithData:data];
    _title = [package.title copy];

    return self;
}


@end
