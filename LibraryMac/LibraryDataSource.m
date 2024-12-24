#import "LibraryDataSource.h"

@import LibraryKit;


@implementation LibraryDataSource


- (NSUInteger)count;
{
    return _library.books.count;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    [_library startScanningForBooks];
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:NSApplicationDidFinishLaunchingNotification
                                               object:nil];

    return self;
}


- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (Book *)objectAtIndexedSubscript:(NSUInteger)index;
{
    return _library.books[index];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return _library.books.count;
}


@end
