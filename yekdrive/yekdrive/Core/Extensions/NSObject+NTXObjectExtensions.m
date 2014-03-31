

#import "NSObject+NTXObjectExtensions.h"

@implementation  NSObject (NTXObjectExtensions)

- (void)removeObserverSafely:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context NS_AVAILABLE(10_7, 5_0)
{
	@try
	{
	[self removeObserver:observer forKeyPath:keyPath context:context];
	}
	@catch (NSException *exception)
    {
	NSLog(@"*********\nCould not remove binding with this exception: %@",exception.debugDescription);
	}
}

@end
