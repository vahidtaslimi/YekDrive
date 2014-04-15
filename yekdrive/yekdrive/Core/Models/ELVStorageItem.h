//
//  ELVStorageItem.h
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELVEnums.h"

@interface ELVStorageItem : NSObject
@property bool isFolder;
@property NSString* name;
@property NSString* itemId;
@property NSString* extension;
@property NSObject* originalObject;
@property  double totalBytes;
@property  NSDate* lastModifiedDate;
@property  NSString* size;
@property  NSString* icon;
@property  NSString* filename;
@property NSString* path;
@property ELVStorageItem* parent;
@property StorageSourceType sourceType;
@property int sourceId;
@property NSString* createdById;
@property NSString* createdByName;
@property BOOL isDeleted;
@property NSString* parentId;
@property NSString* serverUrl;
@property BOOL isShared;

//OneDrive
@property BOOL hasFullFolderTree;
@property NSString* type;

-(NSString*) getLocalPath;
-(NSString*)getLocalFolder;

@end


