//
//  ELVOneDriveRepository.h
//  yekdrive
//
//  Created by VT on 1/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELVIOnlineStorageRepository.h"
#import "ELVStorageItem.h"
#import "LiveSDK/LiveConnectClient.h"

@interface ELVOneDriveRepository : NSObject<ELVIOnlineStorageRepository,LiveOperationDelegate,LiveAuthDelegate, LiveDownloadOperationDelegate>

@property (strong, nonatomic) ELVStorageItem *parent;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (readonly, nonatomic) BOOL isFolder;
@property (readonly, nonatomic) BOOL isImage;

@property (strong, nonatomic) NSArray *folders;
@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) NSData *data;

@property (readonly, nonatomic) NSString *filesPath;
@property (readonly, nonatomic) NSString *downloadPath;
@property (readonly, nonatomic) BOOL hasFullFolderTree;

@property (strong, nonatomic) LiveConnectClient *liveClient;


- (void) loadFolderContent;

- (void) loadFileContent;

@end
