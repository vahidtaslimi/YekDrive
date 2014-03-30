//
//  ELVFilesViewModel.m
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVFilesViewModel.h"
#import "ELVIOnlineStorageRepository.h"
#import "ELVDropboxRepository.h"


@implementation ELVFilesViewModel
{
    id<ELVIOnlineStorageRepository> _dropboxRepository;
    id<ELVIOnlineStorageRepository> _oneDriveRepository;
    id<ELVIOnlineStorageRepository> _boxRepository;
}

- (id)initWithParameters:(id<ELVIOnlineStorageRepository>) dropboxRepository
{
    self = [super init];
    if (self) {
        _dropboxRepository =dropboxRepository;
        _items=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void) loadItems
{
    self.items=[_dropboxRepository get];
}

@end
