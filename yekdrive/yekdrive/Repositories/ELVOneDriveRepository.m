//
//  ELVOneDriveRepository.m
//  yekdrive
//
//  Created by VT on 1/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVOneDriveRepository.h"
#import "ELVIOnlineStorageRepository.h"

@implementation ELVOneDriveRepository
{
     ELVStorageItem* _currentItem;   
}

@synthesize items;
@synthesize isLoading;
@synthesize downloadProgress;
@synthesize lastDownloadedFilename;

-(void)loadItemsInFolder:(ELVStorageItem*)parentFolder
{
    NSString* path=@"/";
    _currentItem=parentFolder;
    if(parentFolder !=nil)
    {
        if(parentFolder.isFolder)
        {
            path=parentFolder.path;
        }
        else{
            [self openFile:parentFolder];
        }
    }
    [self loadFolderContent];
    self.isLoading=true;
 
}

-(BOOL)openFile:(ELVStorageItem* )file
{
    self.downloadProgress=0;
    //DBMetadata* item =(DBMetadata*) file.originalObject ;
    NSString* localPath=[file getLocalPath];
    
    //[self.restClient loadThumbnail:item.path ofSize:@"iphone_bestfit" intoPath:localPath];
    if(![[NSFileManager defaultManager]fileExistsAtPath:localPath])
    {
        NSString* localFolder =[file getLocalFolder];
        if (![[NSFileManager defaultManager] fileExistsAtPath:localFolder]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:localFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
      
    }
    else
    {
        self.lastDownloadedFilename=localPath;
    }
    return true;
}


- (BOOL) isFolder:(ELVStorageItem*)item
{
    return [item.type isEqual:@"folder"] || [self.type isEqual:@"album"];
}

- (BOOL) isImage:(ELVStorageItem*)item
{
    return [item.type isEqual:@"photo"];
}

- (NSString *)filesPath
{
    return [NSString stringWithFormat:@"%@%@", self.objectId, @"/files"];
}

- (NSString *) downloadPath
{
    return [NSString stringWithFormat:@"%@%@", self.objectId, @"/picture?type=normal"];
}

- (BOOL) hasFullFolderTree
{
    BOOL hasFullTree = YES;
    
    if (self.folders != nil) {
        for (NSUInteger i=0; i<self.folders.count; i++) {
            ELVStorageItem *folder = [self.folders objectAtIndex:i];
            if (!folder.hasFullFolderTree) {
                hasFullTree = NO;
                break;
            }
        }
    }
    else {
        hasFullTree = NO;
    }
    
    return hasFullTree;
}

- (void) loadFolderContent
{
        [self.liveClient getWithPath:self.filesPath
                            delegate:self
                           userState:@"load-folder-content"];
    
       // [self.delegate fullFolderTreeLoaded:self];
}

- (void) loadFileContent
{
    assert(!self.isFolder);
    
    if (self.data == nil) {
        [self.liveClient downloadFromPath:self.downloadPath
                                 delegate:self
                                userState:@"load-file-content"];
    }
}

#pragma mark - LiveOperationDelegate


- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    
    if ([operation.userState isEqual:@"load-file-content"])
    {
        LiveDownloadOperation *downloadOp = (LiveDownloadOperation *)operation;
        self.data = downloadOp.data;
        
       // [self.delegate fileContentLoaded:self];
    }
    else if ([operation.userState isEqual:@"load-folder-content"])
    {
        NSMutableArray* currentItems = [NSMutableArray new];
        
        NSDictionary *result = operation.result;
        NSArray *rawFolderObjects = [result objectForKey:@"data"];
        
        for (NSUInteger i=0; i < rawFolderObjects.count; i++) {
            NSDictionary *rawObject = [rawFolderObjects objectAtIndex:i];
            ELVStorageItem* item = [[ELVStorageItem alloc]init];
            
            item.parent = _currentItem;
            item.itemId = [rawObject objectForKey:@"id"];
            item.name = [rawObject objectForKey:@"name"];
            item.type = [rawObject objectForKey:@"type"];
            
            /*
            item.extension = [[child.path pathExtension] lowercaseString];
            item.isFolder =child.isDirectory;
            item.name=child.filename;
            item.itemId=child.hash;
            item.extension=@"";
            item.originalObject=child;
            item.totalBytes=child.totalBytes;
            item.lastModifiedDate=child.lastModifiedDate;
            item.size=child.humanReadableSize;
            item.icon=child.icon;
            item.filename=child.filename;
            item.path=child.path;
            item.parent=_currentItem;
            item.storageSource =StorageSourceTypeDropBox;
            item.isDeleted = child.isDeleted;*/
            
            if ([self isFolder:item])
            {
                item.isFolder = true;
            }
            else
            {
                item.isFolder=false;
            }
            
            [currentItems addObject:item];
        }
        
        self.items = currentItems ;
        self.isLoading=false;
    }
}

- (void) liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    if ([operation.userState isEqual:@"load-folder-content"])
    {
     //   [self.delegate folderContentLoadingFailed:error sender:self];
    }
    else if ([operation.userState isEqual:@"load-file-content"])
    {
       // [self.delegate fileContentLoadingFailed:error sender:self];
    }
}

#pragma mark - PSSkyDriveContentLoaderDelegate

- (void) folderContentLoaded: (ELVStorageItem *) sender
{
    // wait for full folder tree loaded.
}

- (void) fullFolderTreeLoaded: (ELVStorageItem *) sender
{
    [self loadFolderContent];
}

- (void) folderContentLoadingFailed: (NSError *)error
                             sender: (ELVStorageItem *) sender
{
    //[self.delegate folderContentLoadingFailed:error sender:self];
}

- (void) fileContentLoaded: (ELVStorageItem *) sender
{
    // We don't load file from here. The callback should not happen here.
}

- (void) fileContentLoadingFailed: (NSError *)error
                           sender: (ELVStorageItem *) sender
{
    // We don't load file from here. The callback should not happen here.
}

@end
