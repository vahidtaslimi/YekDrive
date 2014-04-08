
#import "ELVLocalStorageHelper.h"
#import "ELVConstants.h"

NSString * NTXLocalStorageHelperKeyStoreIdentifier = @"NintexPasswordVault";

@implementation ELVLocalStorageHelper
{
    NSURL * _rootFolderUrl;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        _rootFolderUrl = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }
    
    return self;
}

-(BOOL)copyItemAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath error:(NSError **)error
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:error];
}

-(BOOL) createFolder:(NSString *)folderName error:(NSError **)error
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * folderUrl = [_rootFolderUrl URLByAppendingPathComponent:folderName isDirectory:YES];
    
    NSLog(@"Creating folder %@", folderUrl);
    BOOL result = [fileManager createDirectoryAtURL:folderUrl
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:error];
    
    if (!result)
        NSLog(@"Failed to created folder.");
    
    return result;
}

-(BOOL) deleteFolder:(NSString *)path error:(NSError **)error
{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

- (void) deleteProfileFolder:(int)profileId
{
    NSString * attachmentsPath = [self getPathProfileRoot:profileId];
    [[NSFileManager defaultManager] removeItemAtPath:attachmentsPath error:nil];
}

-(BOOL) fileExistsAtPath:(NSString *)path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

-(NSString *) generateOfflinePathTasksLinkedAttachment:(NSString*)stringFormat profileId:(int)profileId itemInstanceId:(int)itemInstanceId
{
    return [NSString stringWithFormat:stringFormat, profileId, itemInstanceId];
}

-(NSString *) getRootFolderPath
{
    return [_rootFolderUrl path];
}

-(NSString *) makeUserNameSafe:(NSString *) userName
{
    NSString * cleanUserName = userName;
    
    // The only illegal character for file and folder names in OS X is ":"
    // However to keep the username in line with windows we are removing the
    // illegal Windows characters.  Windows does not allow a folder name to
    // start or end with ".".
    
    // Illegal Characters
    // OS X illegal characters: :
    // Windows illegal characters: / ? < > \ : * | "
    NSCharacterSet * illegalGeneralCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/?<>\\:*|\""];
    cleanUserName = [[cleanUserName componentsSeparatedByCharactersInSet:illegalGeneralCharacters] componentsJoinedByString:@""];
    cleanUserName = [cleanUserName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSCharacterSet * illegalStartEndCharacter = [NSCharacterSet characterSetWithCharactersInString:@"."];
    cleanUserName = [cleanUserName stringByTrimmingCharactersInSet:illegalStartEndCharacter];
    
    return cleanUserName;
}

-(NSData *) readFile:(NSString *)fileName folderName:(NSString *)folderName error:(NSError **)error
{
    NSURL * fileUrl = [[_rootFolderUrl URLByAppendingPathComponent:folderName isDirectory:YES] URLByAppendingPathComponent:fileName];
    
    NSLog(@"Reading file %@", fileUrl);
    
    return [NSData dataWithContentsOfURL:fileUrl options:NSDataReadingUncached error:error];
}

-(BOOL) writeFile:(NSData *)data fileName:(NSString *)fileName folderName:(NSString *)folderName error:(NSError **)error
{
    [self createFolder:folderName error:error];
    NSURL * fileUrl = [[_rootFolderUrl URLByAppendingPathComponent:folderName isDirectory:YES] URLByAppendingPathComponent:fileName];
    NSLog(@"Writting to file %@", fileUrl);

    BOOL result = [data writeToURL:fileUrl options:NSDataWritingFileProtectionNone error:error];
    
    if (!result)
        NSLog(@"Failed to write to file.");
    
    return result;
}

- (NSString *) getPathProfileRoot:(int)profileId {
	return [[self getRootFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat: @"Data/%i", profileId]];
}

- (NSString *) getPathFormsAttachmentRoot:(int)profileId instanceId:(int)instanceId {
	return [[self getRootFolderPath] stringByAppendingPathComponent:[self getPathFormsAttachment:profileId instanceId:instanceId]];
}

- (NSString *) getPathFormsAttachmentFileNameRoot:(int)profileId instanceId:(int)instanceId fileName:(NSString*)fileName {
	return [[self getRootFolderPath] stringByAppendingPathComponent:[self getPathFormsFileNameAttachment:profileId instanceId:instanceId fileName:fileName]];
}

- (NSString *) getPathFormsAttachment:(int)profileId instanceId:(int)instanceId {
    return [NSString stringWithFormat: @"Data/%i/Forms/%i", profileId, instanceId];
}

- (NSString *) getPathFormsFileNameAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString*)fileName {
    return [NSString stringWithFormat: @"Data/%i/Forms/%i/%@", profileId, instanceId, fileName];
}

- (NSString *) getFullPathFormsAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString*) fileName {
	NSString * fullPath = [self getPathFormsAttachmentFileNameRoot:profileId instanceId:instanceId fileName:fileName];
    return fullPath;
}

- (NSString *) getPathTasksAttachmentRoot:(int)profileId instanceId:(int)instanceId {
	return [[self getRootFolderPath] stringByAppendingPathComponent:[self getPathTasksAttachment:profileId instanceId:instanceId]];
}

- (NSString *) getPathTasksAttachmentFileNameRoot:(int)profileId instanceId:(int)instanceId fileName:(NSString*)fileName {
	return [[self getRootFolderPath] stringByAppendingPathComponent:[self getPathTasksFileNameAttachment:profileId instanceId:instanceId fileName:fileName]];
}

- (NSString *) getPathTasksAttachment:(int)profileId instanceId:(int)instanceId {
	return [NSString stringWithFormat: @"Data/%i/Tasks/%i", profileId, instanceId];
}

- (NSString *) getPathTasksFileNameAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString*) fileName {
    return [NSString stringWithFormat: @"Data/%i/Tasks/%i/%@", profileId, instanceId, fileName];
}

- (NSString *) getFullPathTasksAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString*) fileName {
	NSString * fullPath = [self getPathTasksAttachmentFileNameRoot:profileId instanceId:instanceId fileName:fileName];
    return fullPath;
}

- (NSString *) getPathTasksLinkedAttachment:(int)profileId instanceId:(int)instanceId fileName:(NSString*) fileName {
	return [[self getRootFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat: @"Data/%i/Tasks/%i/Linked/%@", profileId, instanceId, fileName]];
}

-(NSString *) getPathDatabase {
	return [[self getRootFolderPath] stringByAppendingPathComponent:@"Data/NM.sqlite"];
}




-(int) getUserDefaultsValueAsInit:(NSString *)key
{
    NSUserDefaults * userSettings = [NSUserDefaults standardUserDefaults];
    return [userSettings integerForKey:key];
}

-(void) setUserDefaultsValueAsInit:(int)value key:(NSString *)key
{
    NSUserDefaults * userSettings = [NSUserDefaults standardUserDefaults];
    [userSettings setInteger:value forKey:key];
    [userSettings synchronize];
}

-(BOOL) createFolderAtPath:(NSString *)path folderName:(NSString *)folderName error:(NSError **)error
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * folderUrl = [[NSURL alloc] initFileURLWithPath:path isDirectory:true];
    
    if (folderName != nil)
        folderUrl = [folderUrl URLByAppendingPathComponent:folderName isDirectory:true];
    
    NSLog(@"Creating folder %@", folderUrl);
    BOOL result = [fileManager createDirectoryAtURL:folderUrl
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:error];
    
    if (!result)
        NSLog(@"Failed to created folder.");
    
    return result;
}

-(BOOL) writeFileAtPath:(NSString *)path
               fileName:(NSString *)fileName
                   data:(NSData *)data
                  error:(NSError **)error
{
    NSURL * fileUrl = [[[NSURL alloc] initFileURLWithPath:path isDirectory:true] URLByAppendingPathComponent:fileName];
    
    NSLog(@"Writting to file %@", fileUrl);
    
    BOOL result = [data writeToURL:fileUrl options:NSDataWritingFileProtectionNone error:error];
    
    if (!result)
        NSLog(@"Failed to write to file.");
    
    return result;
}

-(NSArray *) contentsOfDirectoryAtPath:(NSString *)folderPath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * folderUrl = [[NSURL alloc] initFileURLWithPath:folderPath isDirectory:true];
    
    NSError * error;
    NSArray * allUrlsInDirectory = [fileManager contentsOfDirectoryAtURL:folderUrl
                                              includingPropertiesForKeys:nil
                                                                 options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                   error:&error];
    
    NSMutableArray * fileUrls = [[NSMutableArray alloc] init];
    BOOL isDirectory = NO;
    
    for(NSURL * url in allUrlsInDirectory)
    {
        if ([fileManager fileExistsAtPath:[url path] isDirectory:&isDirectory] && !isDirectory)
            [fileUrls addObject:url];
    }
    
    return fileUrls;
}

- (NSString *) getPathResourceWithSourceId:(NSString *)sourceId profileId:(int)profileId
{
    return [[self getRootFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat: @"Data/%i/Resources/%@", profileId, sourceId]];
}

- (NSString *) getPathResourceWithResourceId:(NSString *)resourceId sourceId:(NSString *)sourceId profileId:(int)profileId
{
    return [[self getPathResourceWithSourceId:sourceId profileId:profileId] stringByAppendingPathComponent:[NSString stringWithFormat: @"/%@", resourceId]];
}

- (long long) sizeOfFileAtUrl:(NSURL *)url
{
    long long fileSize = -1;
    
    NSString * urlPath = [url path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:urlPath error:nil];
    if (fileAttributes)
    {
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        if (fileSizeNumber)
            fileSize = [fileSizeNumber longLongValue];
    }
    return fileSize;
}

- (BOOL) moveItemAtURL:(NSURL *)sourceUrl destinationUrl:(NSURL *)destinationUrl error:(NSError **)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtURL:sourceUrl toURL:destinationUrl error:error];
}

@end
