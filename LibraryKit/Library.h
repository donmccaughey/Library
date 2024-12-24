#import <Foundation/Foundation.h>


@class Book;


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const WillStartScanningForBooksNotification;
extern NSNotificationName const DidFinishScanningForBooksNotification;


@interface Library : NSObject

@property (copy, readonly) NSOrderedSet<Book *> *books;
@property (copy, readonly) NSArray<NSString *> *dirs;

- (void)sortBy:(NSArray<NSSortDescriptor *> *)descriptors;

- (void)startScanningForBooksInDirs:(NSArray<NSString *> *)dirs;

@end


NS_ASSUME_NONNULL_END
