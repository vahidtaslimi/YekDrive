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
#import "NSObject+NTXObjectExtensions.h"

static NSString *ELVFileListingViewModelDropboxKvoContext = @"ELVFileListingViewModelDropboxKvoContext";

@implementation ELVFilesViewModel
{
    NSObject<ELVIOnlineStorageRepository> *_dropboxRepository;
    id<ELVIOnlineStorageRepository> _oneDriveRepository;
    id<ELVIOnlineStorageRepository> _boxRepository;
}


- (id)initWithParameters:(id<ELVIOnlineStorageRepository>) dropboxRepository
{
    self = [super init];
    if (self) {
        _dropboxRepository =dropboxRepository;
        _items=[[NSMutableArray alloc]init];
        [self setupBindings];
    }
    return self;
}

-(void) loadItemsInFolder:(ELVStorageItem*)parentFolder
{
    [_dropboxRepository loadItemsInFolder:parentFolder];
    
}
-(void)openItem:(ELVStorageItem *)item
{
    [_dropboxRepository openFile:item];
}

-(void) loadItemsWithBock:(loadBlockSuccess)successBlock andFailureBlock:(loadBlockFailure)failureBlock
{
    [_dropboxRepository loadItemsInFolder:nil];
    successBlock(_dropboxRepository.items);
}


- (void) dealloc
{
    [self removeBindings];
}

#pragma mark - Binding section

- (void) removeBindings
{
    [_dropboxRepository removeObserverSafely:self forKeyPath:@"items" context:&ELVFileListingViewModelDropboxKvoContext];
    [_dropboxRepository removeObserverSafely:self forKeyPath:@"lastDownloadedFilename" context:&ELVFileListingViewModelDropboxKvoContext];
        [_dropboxRepository removeObserverSafely:self forKeyPath:@"downloadProgress" context:&ELVFileListingViewModelDropboxKvoContext];
}

- (void) setupBindings
{
    [_dropboxRepository addObserver:self forKeyPath:@"items" options:NSKeyValueObservingOptionNew context:&ELVFileListingViewModelDropboxKvoContext];
    [_dropboxRepository addObserver:self forKeyPath:@"lastDownloadedFilename" options:NSKeyValueObservingOptionNew context:&ELVFileListingViewModelDropboxKvoContext];
    [_dropboxRepository addObserver:self forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:&ELVFileListingViewModelDropboxKvoContext];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqual:@"items"])
    {
        if ([change objectForKey:NSKeyValueChangeNewKey] == [NSNull null])
        {
            return;
        }
        NSMutableArray* tempItems=_dropboxRepository.items;
        
        NSSortDescriptor *folderSorter = [[NSSortDescriptor alloc] initWithKey:@"isFolder" ascending:false];
        NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];        
        [tempItems sortUsingDescriptors:[NSArray arrayWithObjects:folderSorter, nameSorter, nil]];
        
        self.items =tempItems;
    }
    else if ([keyPath isEqual:@"lastDownloadedFilename"])
    {
        self.lastDownloadedFilename = _dropboxRepository.lastDownloadedFilename;
    }
    else if ([keyPath isEqual:@"downloadProgress"])
    {
        self.downloadProgress =  _dropboxRepository.downloadProgress;
    }
    else if ([keyPath isEqual:@"isProgressVisible"])
    {
    }
}
@end
