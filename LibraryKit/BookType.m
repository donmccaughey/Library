#include "BookType.h"


static struct {
    enum BookType type;
    NSString *extension;
    NSString *name;
} metaData[] = {
    {
        .type=BookTypeUnknown,
        .extension=@"",
        .name=@"Unknown",
    },
    {
        .type=BookTypeEPUB,
        .extension=@"epub",
        .name=@"EPUB",
    },
    {
        .type=BookTypePDF,
        .extension=@"pdf",
        .name=@"PDF",
    },
};
static NSUInteger metaDataCount = sizeof metaData / sizeof metaData[0];


NSString *
bookTypeExtension(enum BookType type)
{
    NSCAssert(type < metaDataCount, @"Undefined BookType case %lu", type);
    return metaData[type].extension;
}


NSString *
bookTypeName(enum BookType type)
{
    NSCAssert(type < metaDataCount, @"Undefined BookType case %lu", type);
    return metaData[type].name;
}
