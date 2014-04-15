//
//  ELVDropboxRepository.h
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IELVOnlineStorageRepository.h"
#import <DropboxSDK/DropboxSDK.h>

@interface ELVDropboxRepository : NSObject<IELVOnlineStorageRepository,DBRestClientDelegate>

@property (nonatomic, readonly) DBRestClient* restClient;
@property BOOL working;

@end
