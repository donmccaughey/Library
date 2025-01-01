#include "Format.h"

#include "File/EPUB.h"
#include "File/PDF.h"


struct formatProperties {
    Format format;
    NSString *extension;
    NSString *name;
    Class cls;
};


static struct formatProperties *
getformatProperties(Format format)
{
    static struct formatProperties properties[] = {
        {
            .format=FormatUnknown,
            .extension=@"",
            .name=@"Unknown",
            .cls=nil,
        },
        {
            .format=FormatEPUB,
            .extension=@"epub",
            .name=@"EPUB",
            .cls=nil,
        },
        {
            .format=FormatPDF,
            .extension=@"pdf",
            .name=@"PDF",
            .cls=nil,
        },
    };
    static NSUInteger propertiesCount = sizeof properties / sizeof properties[0];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        properties[1].cls = [EPUB class];
        properties[2].cls = [PDF class];
    });

    NSCAssert(format < propertiesCount, @"Undefined Format %lu", format);
    return &properties[format];
}


NSString *
extensionForFormat(Format format)
{
    return getformatProperties(format)->extension;
}


Class<File>
fileClassForFormat(Format format)
{
    return getformatProperties(format)->cls;
}


Format
formatForExtension(NSString *extension)
{
    if ([extensionForFormat(FormatEPUB) isEqualToString:extension]) {
        return FormatEPUB;
    }
    if ([extensionForFormat(FormatPDF) isEqualToString:extension]) {
        return FormatPDF;
    }
    return FormatUnknown;
}


NSString *
nameForFormat(Format format)
{
    return getformatProperties(format)->name;
}
