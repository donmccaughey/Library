#import "AppDelegate.h"

@import LibraryKit;

#import "InfoView.h"
#import "Notifications.h"


void
logTimeInterval(const char* label, struct timespec diff);

struct timespec
timespecDiff(struct timespec start, struct timespec end);


@implementation AppDelegate
{
    NSOrderedSet<Book *> *_books;
    NSArray<NSSortDescriptor *> *_bookSort;
    Library *_library;
    struct timespec _startTime;
}


- (void)libraryDidFinishScanningForBooks:(NSNotification *)notification;
{
    _books = [NSOrderedSet orderedSetWithArray:[_library.books sortedArrayUsingDescriptors:_bookSort]];
    [_tableView reloadData];
    if (_books.count) {
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                byExtendingSelection:NO];
    } else {
        [self postBookSelectionDidChangeNotification];
    }
    
    struct timespec endTime;
    clock_gettime(CLOCK_UPTIME_RAW, &endTime);
    struct timespec loadTime = timespecDiff(_startTime, endTime);
    logTimeInterval("Load time", loadTime);
}


- (void)postBookSelectionDidChangeNotification;
{
    Book *book = _tableView.selectedRow >= 0
            ? _books[_tableView.selectedRow]
            : nil;
    NSDictionary *userInfo = @{
        BookSelectionDidChangeBookKey: book ?: [NSNull null],
        BookSelectionDidChangeCountKey: @(_books.count),
        BookSelectionDidChangeIndexKey: @(_tableView.selectedRow),
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:BookSelectionDidChangeNotification
                                                        object:self
                                                      userInfo:userInfo];
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _bookSort = @[
        [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"fileSize" ascending:YES],
    ];
    
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    clock_gettime(CLOCK_UPTIME_RAW, &_startTime);
    [_library startScanningForBooks];
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app;
{
    return YES;
}


- (void)applicationWillFinishLaunching:(NSNotification *)notification;
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(libraryDidFinishScanningForBooks:)
                                                 name:LibraryDidFinishScanningForBooksNotification
                                               object:nil];
    
    NSArray<NSString *> *dirs = @[
        @"/Users/donmcc/Documents",
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library",
    ];
    _library = [[Library alloc] initWithDirs:dirs];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return _books.count;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
    [self postBookSelectionDidChangeNotification];
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row;
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"BookCell"
                                                            owner:self];
    if ( ! cellView) {
        cellView = [NSTableCellView new];
        cellView.identifier = @"BookCell";
        
        NSTextField *textField = [NSTextField new];
        textField.bezeled = NO;
        textField.drawsBackground = NO;
        textField.editable = NO;
        textField.selectable = YES;
        
        cellView.textField = textField;
        [cellView addSubview:textField];
        
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [textField.leadingAnchor constraintEqualToAnchor:cellView.leadingAnchor constant:2],
            [textField.trailingAnchor constraintEqualToAnchor:cellView.trailingAnchor constant:-2],
            [textField.topAnchor constraintEqualToAnchor:cellView.topAnchor],
            [textField.bottomAnchor constraintEqualToAnchor:cellView.bottomAnchor]
        ]];
    }
    
    Book *book = _books[row];
    cellView.textField.stringValue = book.title;
    
    return cellView;
}


@end


void
logTimeInterval(const char* label, struct timespec diff)
{
   if (diff.tv_sec > 0) {
       double seconds = diff.tv_sec + diff.tv_nsec / 1e9;
       NSLog(@"%s: %.1f seconds", label, seconds);
   } else if (diff.tv_nsec >= 1000000) {
       double milliseconds = diff.tv_nsec / 1e6;
       NSLog(@"%s: %.1f milliseconds", label, milliseconds);
   } else {
       double microseconds = diff.tv_nsec / 1e3;
       NSLog(@"%s: %.1f microseconds", label, microseconds);
   }
}


struct timespec
timespecDiff(struct timespec start, struct timespec end)
{
    struct timespec diff;
    if (end.tv_nsec < start.tv_nsec) {
        diff.tv_sec = end.tv_sec - start.tv_sec - 1;
        diff.tv_nsec = 1000000000 + end.tv_nsec - start.tv_nsec;
    } else {
        diff.tv_sec = end.tv_sec - start.tv_sec;
        diff.tv_nsec = end.tv_nsec - start.tv_nsec;
    }
    return diff;
}
