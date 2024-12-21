#import "AppDelegate.h"

@import LibraryKit;

#import "InfoView.h"
#import "loaders.h"
#import "Notifications.h"


@implementation AppDelegate
{
    NSArray<Book *> *_books;
    NSArray<NSSortDescriptor *> *_bookSort;
    Library *_library;
}


- (Library *)library;
{
    return _library;
}


- (void)setLibrary:(Library *)library;
{
    _library = library;
    _books = [library.books sortedArrayUsingDescriptors:_bookSort];
    [_tableView reloadData];
    [self bookWasSelected];
}


- (void)bookWasSelected;
{
    Book *book = _tableView.selectedRow >= 0
            ? _library.books[_tableView.selectedRow]
            : nil;
    NSDictionary *userInfo = @{
        BookSelectedBookKey: book ?: [NSNull null],
        BookSelectedCountKey: @(_library.books.count),
        BookSelectedIndexKey: @(_tableView.selectedRow),
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:BookSelectedNotification
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
    NSArray<NSString *> *dirs = @[
        @"/Users/donmcc/Documents",
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library",
    ];
    loadLibrary(dirs);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app;
{
    return YES;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return _library.books.count;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
    [self bookWasSelected];
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
