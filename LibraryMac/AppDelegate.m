#import "AppDelegate.h"

@import LibraryKit;

#import "InfoView.h"
#import "loaders.h"


@implementation AppDelegate
{
    Library *_library;
}


- (Library *)library;
{
    return _library;
}


- (void)setLibrary:(Library *)library;
{
    _library = library;
    [_tableView reloadData];
    Book *book = nil;
    if (_tableView.selectedRow >= 0) book = _library.books[_tableView.selectedRow];
    [_infoView updateWithBooksCount:_library.books.count
                      selectedIndex:_tableView.selectedRow
                            andBook:(Book *)book];
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
    Book *book = nil;
    if (_tableView.selectedRow >= 0) book = _library.books[_tableView.selectedRow];
    [_infoView updateWithBooksCount:_library.books.count
                      selectedIndex:_tableView.selectedRow
                            andBook:(Book *)book];
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
    
    Book *book = _library.books[row];
    cellView.textField.stringValue = book.title;
    
    return cellView;
}


@end
