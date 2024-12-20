#import "InfoView.h"

@import LibraryKit;


@implementation InfoView


- (void)updateWithBooksCount:(NSInteger)count
               selectedIndex:(NSInteger)selectedIndex
                     andBook:(Book *)book;
{
    if (selectedIndex == -1) {
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld books", count];
        _sizeLabel.stringValue = @"";
    } else {
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld of %ld books", selectedIndex + 1, count];
        _sizeLabel.stringValue = [NSByteCountFormatter stringFromByteCount:book.fileSize.longLongValue countStyle:NSByteCountFormatterCountStyleFile];
    }
}


@end
