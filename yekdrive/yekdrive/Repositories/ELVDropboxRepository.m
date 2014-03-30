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
    NSMutableArray* currentItems;
    NSString* photosHash;
    DBRestClient* restClient;
}


-(NSMutableArray*)get
{
    return currentItems;
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
    //NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", nil];
    NSMutableArray* items = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
        item=[[ELVStorageItem alloc]init];
        item.extension = [[child.path pathExtension] lowercaseString];
        
       // if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [items addObject:child];
       // }
    }

    currentItems = items;
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
  
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);

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
