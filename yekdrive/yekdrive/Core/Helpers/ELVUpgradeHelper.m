

#import "ELVUpgradeHelper.h"
#import "IELVDatabaseStorageHelper.h"
#import "ELVConstants.h"
#import "IELVLocalStorageHelper.h"
#import "ELVLocalStorageHelper.h"
#import "ELVDatabaseStorageHelper.h"

@implementation NTXUpgradeHelper
{
    id<IELVDatabaseStorageHelper>  _dbHelper;
    id<IELVLocalStorageHelper> _localStorageHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dbHelper = [[ELVDatabaseStorageHelper alloc]init];
        _localStorageHelper = [[ELVLocalStorageHelper alloc]init];
    }
    return self;
}

- (NSString *) getCurrentDatabaseVersion
{
    return NTXVersion2_3;
}

-(void) performUpgrades
{
    NSString * previousDbVersion = [_dbHelper getApplicationSettingByName:ELVDBAppSettingDatabaseVersion];
    
    bool success = false;
    
    if (previousDbVersion.length == 0 || [previousDbVersion isEqualToString:NTXVersion0_1])
        success = [self performUpdateFrom0_1];
    else if ([previousDbVersion isEqualToString:NTXVersion0_2])
        success = [self performUpdateFrom0_2];
    else if ([previousDbVersion isEqualToString:NTXVersion1_0])
        success = [self performUpdateFrom1_0];
    else if ([previousDbVersion isEqualToString:NTXVersion1_1])
        success = [self performUpdateFrom1_1];
    else if ([previousDbVersion isEqualToString:NTXVersion2_0])
        success = true;
    else if ([previousDbVersion isEqualToString:NTXVersion2_2])
        success = true;

    //if (!success)
    //    @throw [NSException exceptionWithName:NSGenericException reason:@"NTXUpgradeHelper failed to update application" userInfo:NULL];

    if (success)
    {
        NSString * currentDatabaseVersion = [self getCurrentDatabaseVersion];
        [_dbHelper setApplicationSettingValue:currentDatabaseVersion forSettingName:ELVDBAppSettingDatabaseVersion];
    }
}

-(bool) performUpdateFrom0_1
{
    // First thing is to create the DbAppSettings table
   // [_dbHelper createAppSettingsTable];
    
    // Call next in the chain
    return [self performUpdateFrom0_2];
}

-(bool) performUpdateFrom0_2
{
    // Do nothing for this update
    
    // Call next in the chain
    return [self performUpdateFrom1_0];
}

-(bool) performUpdateFrom1_0
{
    // First thing is to create the DbAppSettings table
    //[_dbHelper createNewTableColumn:@"DbCachedFormInstance" column:@"Icon" type:@"VARCHAR"];
    
    // Add the UseMeteredNetworks column.
   // [_dbHelper createNewTableColumn:@"DbProfile" column:@"UseMeteredNetworks" type:@"BOOL"];
   // [_dbHelper upgradeFlagWorkOfflineOffForAllProfiles];
    
    return [self performUpdateFrom1_1];

}

-(bool) performUpdateFrom1_1
{
   
    return true;
}

@end
