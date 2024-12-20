#import "AppDelegate.h"

@import LibraryKit;

#import "InfoView.h"
#import "loaders.h"


@implementation AppDelegate {
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
    [_infoView updateWithBooksCount:_library.books.count
                   andSelectedIndex:_tableView.selectedRow];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    NSArray<NSString *> *dirs = @[
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library/Games",
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
    [_infoView updateWithBooksCount:_library.books.count
                   andSelectedIndex:_tableView.selectedRow];
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
    cellView.textField.stringValue = book.path.lastPathComponent;
    
    return cellView;
}


@end
