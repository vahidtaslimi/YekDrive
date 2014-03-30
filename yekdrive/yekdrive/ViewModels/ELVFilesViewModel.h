//
//  ELVFilesViewModel.h
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELVIOnlineStorageRepository.h"

@interface ELVFilesViewModel : NSObject

@property NSMutableArray* items;

- (id)initWithParameters:(id<ELVIOnlineStorageRepository>) dropboxRepository;

-(void) loadItems;

@end
