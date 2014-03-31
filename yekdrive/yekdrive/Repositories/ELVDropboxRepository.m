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
}

@synthesize items;
@synthesize isLoading;


-(void)loadItems
{
    self.isLoading=true;
    [self.restClient loadMetadata:@"/"];
}

-(BOOL)openFile:(ELVStorageItem* )file
{
    DBMetadata* item =(DBMetadata*) file.originalObject ;
    NSString* localPath=[self getFullPath:file];
    [self.restClient loadThumbnail:item.path ofSize:@"iphone_bestfit" intoPath:localPath];
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
        [currentItems addObject:item];
    }
    
    self.items =   currentItems ;
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
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

@end
