#include "Format.h"


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


NSString *
formatName(enum Format format)
{
    NSCAssert(format < formatsCount, @"Undefined Format %lu", format);
    return formats[format].name;
}
