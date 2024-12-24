#import "BookListViewController.h"

@import LibraryKit;

#import "LibraryDataSource.h"
#import "Notifications.h"


@implementation BookListViewController
{
    NSArray<NSSortDescriptor *> *_bookSort;
}


- (void)didFinishScanningForBooks:(NSNotification *)notification;
{
    [_libraryDataSource.library sortBy:_bookSort];
    [_tableView reloadData];
    if (_libraryDataSource.count) {
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                byExtendingSelection:NO];
    } else {
        [self updateSelectedBook];
    }
}


- (void)updateSelectedBook;
{
    if (_tableView.selectedRow >= 0) {
        Book *book = _libraryDataSource[_tableView.selectedRow];
        NSDictionary *userInfo = @{
            BookKey: book,
            CountKey: @(_libraryDataSource.count),
            IndexKey: @(_tableView.selectedRow),
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:DidSelectBookNotification
                                                            object:self
                                                          userInfo:userInfo];
        if ( ! book.isOpen) [book startOpening];
    } else {
        NSDictionary *userInfo = @{
            BookKey: [NSNull null],
            CountKey: @(_libraryDataSource.count),
            IndexKey: @(_tableView.selectedRow),
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:DidSelectBookNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
}


- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad;
{
    _bookSort = @[
        [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"fileSize" ascending:YES],
    ];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishScanningForBooks:)
                                                 name:DidFinishScanningForBooksNotification
                                               object:nil];
    [super viewDidLoad];
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
    
    Book *book = _libraryDataSource[row];
    cellView.textField.stringValue = book.title;
    
    return cellView;
}


@end
