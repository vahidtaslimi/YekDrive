//
//  ELVIOnlineStorageRepository.h
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELVStorageItem.h"

@protocol ELVIOnlineStorageRepository <NSObject>
@required
-(NSMutableArray*)get;
-(BOOL)openFile:(ELVStorageItem* )file;

@end
