#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface XMLNamespaceMap : NSObject

- (nullable NSString *)namespaceURIForPrefix:(NSString *)prefix;

- (NSSet<NSString *> *)prefixesForNamespaceURI:(NSString *)namespaceURI;

- (NSSet<NSString *> *)qualifiedNamesForAttribute:(NSString *)attributeName
                                      inNamespace:(NSString *)namespaceURI;

- (void)pushPrefix:(NSString *)prefix forNamespaceURI:(NSString *)namespaceURI;

- (void)popPrefix:(NSString *)prefix;

@end


NS_ASSUME_NONNULL_END
