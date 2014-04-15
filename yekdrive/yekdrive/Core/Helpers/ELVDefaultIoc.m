//
//  ELVDefaultIoc.m
//  yekdrive
//
//  Created by VT on 9/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVDefaultIoc.h"
#import "IELVLocalStorageHelper.h"
#import "ELVLocalStorageHelper.h"
#import "IELVDatabaseStorageHelper.h"
#import "ELVDatabaseStorageHelper.h"
#import "IELVOnlineStorageRepository.h"
#import "ELVOneDriveRepository.h"



@implementation ELVDefaultIoc


- (id)init
{
    self = [super init];
    
    return self;
}

- (void) configure
{
    //Helpers
    [self bindClass:[ELVLocalStorageHelper class] toProtocol:@protocol(IELVLocalStorageHelper)];
    [self bindClass:[ELVDatabaseStorageHelper class] toProtocol:@protocol(IELVDatabaseStorageHelper)];
    
    // Repositories
    [self bindClass:[ELVOneDriveRepository class] toProtocol:@protocol(IELVOnlineStorageRepository)];
    
    /*
     [self bindClass:[NTXAccountSettingCachedRepository class] toProtocol:@protocol(INTXAccountSettingRepository)];
     [self bindClass:[NTXAccountSettingCachedRepository class] inScope:JSObjectionScopeSingleton];
     */
    
}

@end
