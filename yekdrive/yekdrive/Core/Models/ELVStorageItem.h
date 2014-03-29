//
//  ELVStorageItem.h
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELVStorageItem : NSObject
@property bool isFolder;
@property NSString* name;
@property NSString* itemId;
@property NSString* type;

@property  long long totalBytes;
@property  NSDate* lastModifiedDate;
@property  NSString* size;
@property  NSString* icon;
@property  NSString* filename;
@end
