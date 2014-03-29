//
//  ELVDropboxRepository.m
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVDropboxRepository.h"

@implementation ELVDropboxRepository
{
    NSArray* photoPaths;
    NSString* photosHash;
    NSString* currentPhotoPath;
    BOOL working;
    DBRestClient* restClient;
}


-(NSMutableArray*)get
{

    
    return nil;
}



#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {

    photosHash = metadata.hash;
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", nil];
    NSMutableArray* newPhotoPaths = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
        NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newPhotoPaths addObject:child.path];
        }
    }

    photoPaths = newPhotoPaths;
    [self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    [self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    [self displayError];
    [self setWorking:NO];
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    [self setWorking:NO];
    //imageView.image = [UIImage imageWithContentsOfFile:destPath];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
    [self setWorking:NO];
    [self displayError];
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

- (void)loadRandomPhoto {
    if ([photoPaths count] == 0) {
        
        NSString *msg = nil;
        if ([DBSession sharedSession].root == kDBRootDropbox) {
            msg = @"Put .jpg photos in your Photos folder to use DBRoulette!";
        } else {
            msg = @"Put .jpg photos in your app's App folder to use DBRoulette!";
        }
        
        [[[UIAlertView alloc]
           initWithTitle:@"No Photos!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          
         show];
        
        [self setWorking:NO];
    } else {
        NSString* photoPath;
        if ([photoPaths count] == 1) {
            photoPath = [photoPaths objectAtIndex:0];
            if ([photoPath isEqual:currentPhotoPath]) {
                [[[UIAlertView alloc]
                   initWithTitle:@"No More Photos" message:@"You only have one photo to display."
                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
                  
                 show];
                
                [self setWorking:NO];
                return;
            }
        } else {
            // Find a random photo that is not the current photo
            do {
                srandom(time(NULL));
                NSInteger index =  random() % [photoPaths count];
                photoPath = [photoPaths objectAtIndex:index];
            } while ([photoPath isEqual:currentPhotoPath]);
        }
        

        currentPhotoPath = photoPath ;
        
        [self.restClient loadThumbnail:currentPhotoPath ofSize:@"iphone_bestfit" intoPath:[self photoPath]];
    }
}

- (NSString*)photoPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.jpg"];
}

- (void)displayError {
    [[[UIAlertView alloc]
       initWithTitle:@"Error Loading Photo" message:@"There was an error loading your photo."
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
           show];
}

- (void)setWorking:(BOOL)isWorking {
    if (working == isWorking) return;
    working = isWorking;
    
    if (working) {
        //[activityIndicator startAnimating];
    } else {
        //[activityIndicator stopAnimating];
    }
    //nextButton.enabled = !working;
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

@end
