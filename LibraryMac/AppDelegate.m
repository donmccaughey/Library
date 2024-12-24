#import "AppDelegate.h"

@import LibraryKit;

#import "InfoView.h"
#import "LibraryDataSource.h"
#import "Logger.h"
#import "Notifications.h"


@implementation AppDelegate
{
    NSArray<NSSortDescriptor *> *_bookSort;
    Library *_library;
    Logger *_logger;
}


- (void)didFinishScanningForBooks:(NSNotification *)notification;
{
    [_library sortBy:_bookSort];
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
    if (_tableView.selectedRow >= 0) {
        Book *book = _library.books[_tableView.selectedRow];
        NSDictionary *userInfo = @{
            BookKey: book,
            CountKey: @(_library.books.count),
            IndexKey: @(_tableView.selectedRow),
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:DidSelectBookNotification
                                                            object:self
                                                          userInfo:userInfo];
        if ( ! book.isOpen) [book startOpening];
    } else {
        NSDictionary *userInfo = @{
            BookKey: [NSNull null],
            CountKey: @(_library.books.count),
            IndexKey: @(_tableView.selectedRow),
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:DidSelectBookNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _bookSort = @[
        [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"fileSize" ascending:YES],
    ];
    _libraryDataSource = [LibraryDataSource new];
    _logger = [Logger new];
    
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
                                             selector:@selector(didFinishScanningForBooks:)
                                                 name:DidFinishScanningForBooksNotification
                                               object:nil];
    
    NSArray<NSString *> *dirs = @[
        @"/Users/donmcc/Documents",
        @"/Users/donmcc/Downloads",
        @"/Users/donmcc/Dropbox/Books/Don's Library",
    ];
    _library = [[Library alloc] initWithDirs:dirs];
    _libraryDataSource.library = _library;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
