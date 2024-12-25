#import "BookListViewController.h"

@import LibraryKit;

#import "Notifications.h"


@implementation BookListViewController


- (void)libraryDidFinishScanningFolders:(NSNotification *)notification;
{
    [_tableView reloadData];
    if (_library.books.count) {
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                byExtendingSelection:NO];
    } else {
        [self updateSelectedBook];
    }
}


- (void)updateSelectedBook;
{
    Book *book = (_tableView.selectedRow >= 0)
            ? _library.books[_tableView.selectedRow]
            : nil;
    NSDictionary *userInfo = @{
        BookKey: book ?: [NSNull null],
        CountKey: @(_library.books.count),
        IndexKey: @(_tableView.selectedRow),
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:DidSelectBookNotification
                                                        object:self
                                                      userInfo:userInfo];
    if (book && ! book.isOpen) [book startOpening];
}


- (instancetype)initWithCoder:(NSCoder *)coder;
{
    self = [super initWithCoder:coder];
    if ( ! self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(libraryDidFinishScanningFolders:)
                                                 name:LibraryDidFinishScanningFoldersNotification
                                               object:nil];
    
    return self;
}


- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return _library.books.count;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
    [self updateSelectedBook];
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
