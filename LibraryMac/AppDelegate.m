#import "AppDelegate.h"

@import LibraryKit;
#import "InfoView.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    [self loadLibrary];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app;
{
    return YES;
}


- (void)loadLibrary;
{
    _library = [[Library alloc] initWithDirs:@[
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library/Games",
    ]];
    [_library scanDirsForBooks];
    NSLog(@"%li books:", _library.books.count);
    
    [_tableView reloadData];
    [_infoView updateWithBooksCount:_library.books.count
                   andSelectedIndex:_tableView.selectedRow];
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
