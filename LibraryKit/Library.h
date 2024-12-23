#import <Foundation/Foundation.h>


@class Book;


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const WillStartScanningForBooksNotification;
extern NSNotificationName const DidFinishScanningForBooksNotification;


@interface Library : NSObject

@property (copy, readonly) NSOrderedSet<Book *> *books;
@property (copy, readonly) NSArray<NSString *> *dirs;

- (instancetype)initWithDir:(NSString *)dir;

- (instancetype)initWithDirs:(NSArray<NSString *> *)dirs;

- (void)startScanningForBooks;

- (void)sortBy:(NSArray<NSSortDescriptor *> *)descriptors;

@end


NS_ASSUME_NONNULL_END
