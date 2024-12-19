#import "InfoView.h"


@implementation InfoView


//- (instancetype)initWithFrame:(NSRect)frameRect;
//{
//    self = [super initWithFrame:frameRect];
//    if ( ! self) return nil;
//    
//    _countLabel = [NSTextField labelWithString:@""];
//    [self addSubview:_countLabel];
//    [NSLayoutConstraint activateConstraints:@[
//        [_countLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0],
//        [_countLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
//    ]];
//    
//    return self;
//}


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
