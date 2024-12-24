@import Cocoa;


@class Library;


NS_ASSUME_NONNULL_BEGIN


@interface LibraryDataSource : NSObject<NSTableViewDataSource>

@property (nullable) Library *library;

@end


NS_ASSUME_NONNULL_END
