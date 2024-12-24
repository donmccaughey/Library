#import "LibraryDataSource.h"

@import LibraryKit;


@implementation LibraryDataSource


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return _library.books.count;
}


@end
