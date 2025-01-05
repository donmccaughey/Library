#import "XMLNamespaceMap.h"


@interface NSMutableDictionary<KeyType, ObjectType> (NamespaceMap)

- (ObjectType)objectForKey:(KeyType)aKey
                 withClass:(Class)cls;

@end


@implementation XMLNamespaceMap
{
    NSMutableDictionary<NSString *, NSMutableSet<NSString *> *> *_namespaceToPrefixSet;
    NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *_prefixToNamespaceStack;
}


- (instancetype)init;
{
    self = [super init];
    if ( ! self) return nil;
    
    _namespaceToPrefixSet = [NSMutableDictionary new];
    _prefixToNamespaceStack = [NSMutableDictionary new];
    
    return self;
}


- (NSSet<NSString *> *)prefixesForNamespaceURI:(NSString *)namespaceURI;
{
    return _namespaceToPrefixSet[namespaceURI] ?: [NSSet set];
}


- (nullable NSString *)namespaceURIForPrefix:(NSString *)prefix;
{
    return _prefixToNamespaceStack[prefix].lastObject;
}


- (NSSet<NSString *> *)qualifiedNamesForAttribute:(NSString *)attributeName
                                      inNamespace:(NSString *)namespaceURI;
{
    NSMutableSet<NSString *> *qualifiedNames = [NSMutableSet new];
    for (NSString *prefix in [self prefixesForNamespaceURI:namespaceURI]) {
        if (prefix.length) {
            NSString *qualifiedName = [NSString stringWithFormat:@"%@:%@", prefix, attributeName];
            [qualifiedNames addObject:qualifiedName];
        }
    }
    return qualifiedNames;
}


- (void)pushPrefix:(NSString *)prefix forNamespaceURI:(NSString *)namespaceURI;
{
    NSMutableArray<NSString *> *namespaceStack = [_prefixToNamespaceStack objectForKey:prefix
                                                                             withClass:[NSMutableArray class]];
    NSString *currentNamespaceForPrefix = namespaceStack.lastObject;
    if (currentNamespaceForPrefix) {
        [_namespaceToPrefixSet[currentNamespaceForPrefix] removeObject:prefix];
    }
    
    [namespaceStack addObject:namespaceURI];
    
    NSMutableSet<NSString *> *prefixes = [_namespaceToPrefixSet objectForKey:namespaceURI
                                                                   withClass:[NSMutableSet class]];
    [prefixes addObject:prefix];
}


- (void)popPrefix:(NSString *)prefix;
{
    NSMutableArray<NSString *> *namespaceStack = _prefixToNamespaceStack[prefix];
    NSAssert(namespaceStack, @"Expected prefix '%@' to be mapped to a namespace", prefix);
    
    NSString *currentNamespaceForPrefix = namespaceStack.lastObject;
    [namespaceStack removeLastObject];
    
    [_namespaceToPrefixSet[currentNamespaceForPrefix] removeObject:prefix];

    NSString *newNamespace = namespaceStack.lastObject;
    if (newNamespace) {
        NSMutableSet<NSString *> *prefixSet = [_namespaceToPrefixSet objectForKey:newNamespace
                                                                        withClass:[NSMutableSet class]];
        [prefixSet addObject:prefix];
    }
}


@end


@implementation NSMutableDictionary (NamespaceMap)


- (id)objectForKey:(id)aKey
         withClass:(Class)cls;
{
    id object = self[aKey];
    if ( ! object) {
        object = [cls new];
        self[aKey] = object;
    }
    return object;
}


@end
