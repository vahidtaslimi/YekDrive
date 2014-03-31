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
typedef void (^loadBlockSuccess) (NSMutableArray* items);
typedef void (^loadBlockFailure) (NSString* errorMessage);

@property NSMutableArray* items;
@property NSString* lastDownloadedFilename;
@property CGFloat downloadProgress;

- (id)initWithParameters:(id<ELVIOnlineStorageRepository>) dropboxRepository;

-(void) loadItemsInFolder:(ELVStorageItem*)parentFolder;

-(void) loadItemsWithBock:(loadBlockSuccess)successBlock andFailureBlock:(loadBlockFailure)failureBlock;

-(void) openItem:(ELVStorageItem*)item;

@end
