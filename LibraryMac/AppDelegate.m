#import "AppDelegate.h"

@import LibraryKit;

#import "InfoView.h"
#import "Notifications.h"


@implementation AppDelegate
{
    NSArray<Book *> *_books;
    NSArray<NSSortDescriptor *> *_bookSort;
    Library *_library;
}


- (void)libraryDidFinishScanningForBooks:(NSNotification *)notification;
{
     _books = [_library.books sortedArrayUsingDescriptors:_bookSort];
    [_tableView reloadData];
    if (_books.count) {
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                byExtendingSelection:NO];
    } else {
        [self postBookSelectionDidChangeNotification];
    }
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
