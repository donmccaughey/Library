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
    
    NSError *mimetypeError;
    NSString *mimetypePath = [zip pathOfFirstEntryWithError:&mimetypeError];
    if ( ! mimetypePath) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingEPUBZip
                                   underlyingError:zipError
                                        andMessage:@"Unable to find first entry in EPUB file '%@'", path];
        }
        return nil;
    }
    if ( ! [@"mimetype" isEqualToString:mimetypePath]) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingEPUBZip
                                   underlyingError:zipError
                                        andMessage:@"Missing first entry 'mimetype' in EPUB file '%@', found '%@' instead",
                      path, mimetypePath];
        }
        return nil;
    }
    
    NSData *mimetypeData = [zip dataForEntryWithPath:mimetypePath
                                               error:&mimetypeError];
    if ( ! mimetypeData) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingEPUBZip
                                   underlyingError:zipError
                                        andMessage:@"Unable to read '%@' entry in EPUB '%@'",
                      mimetypePath, path];
        }
        return nil;
    }
    
    
    NSString *mimetype = [NSString stringWithCString:mimetypeData.bytes
                                            encoding:NSUTF8StringEncoding];
    if ( ! [@"application/epub+zip" isEqualToString:mimetype]) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingEPUBZip
                                   underlyingError:zipError
                                        andMessage:@"Unexpected mimetype '%@' for EPUB '%@'", mimetype, path];
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
    
    NSError *packageError;
    OPFPackage *package = [[OPFPackage alloc] initWithData:data
                                                     error:&packageError];
    if ( ! package) {
        if (error) {
            *error = [NSError libraryErrorWithCode:LibraryErrorReadingOPFPackageXML
                                   underlyingError:packageError
                                        andMessage:@"Unable to parse '%@' entry in EPUB '%@'", container.packagePath, path];
        }
        return nil;
    }
    
    _title = [package.titles.firstObject copy];

    return self;
}


@end
