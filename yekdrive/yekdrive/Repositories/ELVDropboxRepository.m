//
//  ELVDropboxRepository.m
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVDropboxRepository.h"
#import "ELVStorageItem.h"

@implementation ELVDropboxRepository
{
    NSString* photosHash;
    DBRestClient* restClient;
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
    
    self.isLoading=true;
    [self.restClient loadMetadata:path];
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
        [self.restClient loadFile:file.path intoPath:localPath];
    }
    else
    {
        self.lastDownloadedFilename=localPath;
    }
    return true;
}


#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    
    photosHash = metadata.hash;
    ELVStorageItem* item;
    NSMutableArray* currentItems = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
        item=[[ELVStorageItem alloc]init];
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
        [currentItems addObject:item];
    }
    
    self.items = currentItems ;
    self.isLoading=false;
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    
    self.isLoading=false;
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    
    self.isLoading=false;
    [self setWorking:NO];
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    [self setWorking:NO];
    //imageView.image = [UIImage imageWithContentsOfFile:destPath];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    [self setWorking:NO];
    
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath;
{
    self.lastDownloadedFilename = destPath;
}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
    self.downloadProgress = progress;
}
- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    self.downloadProgress=0;
}
#pragma mark private methods

- (void)didPressRandomPhoto {
    [self setWorking:YES];
    
    NSString *photosRoot = nil;
    if ([DBSession sharedSession].root == kDBRootDropbox) {
        photosRoot = @"/";//@"/Camera Uploads";
    } else {
        photosRoot = @"/";
    }
    
    [self.restClient loadMetadata:photosRoot withHash:photosHash];
}



- (NSString*)getFullPath:(ELVStorageItem*) item {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.jpg"];
    
    NSString * yourPath = @"/folder1/folder2/folder3";
    NSError * error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath: yourPath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    if (!success)
        return @"";
    else
        return yourPath;
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

@end
