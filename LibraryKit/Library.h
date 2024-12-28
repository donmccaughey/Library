#import <Foundation/Foundation.h>


@class Book;


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const LibraryWillStartScanningFoldersNotification;
extern NSNotificationName const LibraryDidFinishScanningFoldersNotification;


@interface Library : NSObject

@property (readonly) NSOrderedSet<Book *> *books;
@property (readonly) NSArray<NSString *> *folders;
@property (copy) NSArray<NSSortDescriptor *> *sortDescriptors;

- (void)startScanningFolders:(NSArray<NSString *> *)folders;

@end


NS_ASSUME_NONNULL_END
