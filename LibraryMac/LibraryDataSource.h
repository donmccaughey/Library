@import Cocoa;


@class Book;
@class Library;


NS_ASSUME_NONNULL_BEGIN


@interface LibraryDataSource : NSObject<NSTableViewDataSource>

@property (readonly) NSUInteger count;
@property (nullable) Library *library;

- (nullable Book *)objectAtIndexedSubscript:(NSUInteger)index;

@end


NS_ASSUME_NONNULL_END
