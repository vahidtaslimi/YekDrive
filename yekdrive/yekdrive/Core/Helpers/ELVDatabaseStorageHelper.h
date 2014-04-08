
#import "ELVLocalStorageHelper.h"
#import "IELVDatabaseStorageHelper.h"

@interface ELVDatabaseStorageHelper : NSObject<IELVDatabaseStorageHelper>



@property id<IELVLocalStorageHelper> localStorageHelper ;

@end
