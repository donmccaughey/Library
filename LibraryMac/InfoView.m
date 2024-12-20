#import "InfoView.h"


@implementation InfoView


- (void)updateWithBooksCount:(NSInteger)count
            andSelectedIndex:(NSInteger)selectedIndex;
{
    if (selectedIndex == -1) {
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld books", count];
    } else {
        _countLabel.stringValue = [NSString stringWithFormat:@"%ld of %ld books", selectedIndex + 1, count];
    }
}


@end
