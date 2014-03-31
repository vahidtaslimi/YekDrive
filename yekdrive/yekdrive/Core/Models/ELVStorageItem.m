//
//  ELVStorageItem.m
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVStorageItem.h"


@implementation ELVStorageItem

-(NSString*)getLocalPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* myLocalPath=  [NSString stringWithFormat:@"%@/%u%@",[paths objectAtIndex:0],self.storageSource,self.path];
    return myLocalPath;
}

-(NSString*)getLocalFolder
{
    NSString* localFolder =[self getLocalPath];
    localFolder =[localFolder stringByReplacingOccurrencesOfString:self.name withString:@""];
    return localFolder;
}

@end
