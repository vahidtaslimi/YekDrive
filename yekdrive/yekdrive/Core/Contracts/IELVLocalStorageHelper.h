//
//  IELVLocalStorageHelper.h
//  yekdrive
//
//  Created by VT on 8/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IELVLocalStorageHelper <NSObject>
- (id)init;

-(BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;

-(BOOL) createFolder:(NSString *)folderName error:(NSError **)error;

-(BOOL) deleteFolder:(NSString *)path error:(NSError **)error;

-(BOOL) fileExistsAtPath:(NSString *)path;

-(NSString *) generateOfflinePathTasksLinkedAttachment:(NSString*)stringFormat profileId:(int)profileId itemInstanceId:(int)itemInstanceId;

-(NSString *) getRootFolderPath;

-(NSString *) getPathProfileRoot:(int)profileId;

-(NSString *) getPathFormsAttachmentRoot:(int)profileId instanceId:(int)instanceId;

-(NSString *) getPathFormsAttachmentFileNameRoot:(int)profileId instanceId:(int)instanceId fileName:(NSString *) fileName;

-(NSString *) getPathFormsAttachment:(int)profileId instanceId:(int)instanceId;

-(NSString *) getPathFormsFileNameAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString *) fileName;

-(NSString *) getFullPathFormsAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString *) fileName;

-(NSString *) getPathTasksAttachmentRoot:(int)profileId instanceId:(int)instanceId;

-(NSString *) getPathTasksAttachmentFileNameRoot:(int)profileId instanceId:(int)instanceId fileName:(NSString *) fileName;

-(NSString *) getPathTasksAttachment:(int)profileId instanceId:(int)instanceId;

-(NSString *) getPathTasksFileNameAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString *) fileName;

-(NSString *) getFullPathTasksAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString *) fileName;

-(NSString *) getPathTasksLinkedAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString *) fileName;

-(NSString *) makeUserNameSafe:(NSString *) userName;

-(NSData *) readFile:(NSString *)fileName folderName:(NSString *)folderName error:(NSError **)error;

-(BOOL) writeFile:(NSData *)data fileName:(NSString *)fileName folderName:(NSString *)folderName error:(NSError **)error;

-(NSString *) getPathDatabase;


-(int) getUserDefaultsValueAsInit:(NSString *)key;

-(void) setUserDefaultsValueAsInit:(int)value key:(NSString *)key;

-(NSArray *) contentsOfDirectoryAtPath:(NSString *)folderPath;

-(BOOL) createFolderAtPath:(NSString *)path folderName:(NSString *)folderName error:(NSError **)error;

-(BOOL) writeFileAtPath:(NSString *)path fileName:(NSString *)fileName data:(NSData *)data error:(NSError **)error;

- (void) deleteProfileFolder:(int)profileId;

- (NSString *) getPathResourceWithResourceId:(NSString *)resourceId sourceId:(NSString *)sourceId profileId:(int)profileId;

- (NSString *) getPathResourceWithSourceId:(NSString *)sourceId profileId:(int)profileId;

- (long long) sizeOfFileAtUrl:(NSURL *)url;

- (BOOL) moveItemAtURL:(NSURL *)sourceUrl destinationUrl:(NSURL *)destinationUrl error:(NSError **)error;

@end
