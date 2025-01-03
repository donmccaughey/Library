#import <Foundation/Foundation.h>


@class Book;
@class ElapsedTime;


NS_ASSUME_NONNULL_BEGIN


extern NSNotificationName const LibraryWillStartScanningFoldersNotification;
extern NSNotificationName const LibraryDidFinishScanningFoldersNotification;


@interface Library : NSObject

@property (readonly) NSOrderedSet<Book *> *books;
@property (readonly) NSArray<NSString *> *folders;
@property (nullable, readonly) ElapsedTime *scanTime;
@property (copy) NSArray<NSSortDescriptor *> *sortDescriptors;

- (void)startScanningFolders:(NSArray<NSString *> *)folders;

@end


NS_ASSUME_NONNULL_END
