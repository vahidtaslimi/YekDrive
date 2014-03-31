#import <Foundation/Foundation.h>

@interface NSObject (NTXObjectExtensions)

- (void)removeObserverSafely:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context NS_AVAILABLE(10_7, 5_0);

@end
