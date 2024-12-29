#include "Format.h"

#include "File/EPUB.h"
#include "File/PDF.h"


static struct {
    enum Format format;
    NSString *extension;
    NSString *name;
} formats[] = {
    {
        .format=FormatUnknown,
        .extension=@"",
        .name=@"Unknown",
    },
    {
        .format=FormatEPUB,
        .extension=@"epub",
        .name=@"EPUB",
    },
    {
        .format=FormatPDF,
        .extension=@"pdf",
        .name=@"PDF",
    },
};
static NSUInteger formatsCount = sizeof formats / sizeof formats[0];


NSString *
extensionForFormat(enum Format format)
{
    NSCAssert(format < formatsCount, @"Undefined Format %lu", format);
    return formats[format].extension;
}


Class<File>
fileClassForFormat(enum Format format)
{
    switch (format) {
        case FormatUnknown: return nil;
        case FormatEPUB: return [EPUB class];
        case FormatPDF: return [PDF class];
        default:
            NSCAssert(NO, @"Undefined Format %lu", format);
            return nil;
    }
}


NSString *
formatName(enum Format format)
{
    NSCAssert(format < formatsCount, @"Undefined Format %lu", format);
    return formats[format].name;
}
