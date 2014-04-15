#import "ELVDatabaseStorageHelper.h"
#import <sqlite3.h>
#import "ELVStorageItem.h"
#import "ELVConstants.h"
#import <Objection-iOS/Objection.h>

static sqlite3 *database = nil;

@implementation ELVDatabaseStorageHelper

objection_requires(@"localStorageHelper");

- (id)init
{
    self = [super init];
    if (self){
        [[JSObjection defaultInjector] injectDependencies:self];
    }
    
    return self;
}


#pragma mark - Item Methods
- (BOOL) doesItemExist:(ELVStorageItem*)item
{
    bool exists = false;
    sqlite3_stmt * existStmt;
    
    const char * existSql = "select exists (SELECT 1 FROM files WHERE Id = ? and SourceType = ?)";
    

        if(sqlite3_prepare_v2(database, existSql, -1, &existStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        
        sqlite3_bind_text(existStmt, 1, [item.itemId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(existStmt, 2, item.sourceType);
        
        if (SQLITE_ROW == sqlite3_step(existStmt))
        {
            if (sqlite3_column_int(existStmt, 0) != 0)
                exists = true;
        }
        sqlite3_finalize(existStmt);
    
    return exists;
    
}

- (void) addOrUpdateItem:(ELVStorageItem*)item
{
    
    
    if (![self doesItemExist:item])
    {
        // Add
        sqlite3_stmt * addStmt;
        const char * addSql = "INSERT INTO files (Id,Name,Size,IconUrl,LastModified,Filename,Path,IsFolder,IsDeleted,ParentId,ServerUrl,SourceId,SourceType,CreatedById,CreatedByName,IsShared) VALUES (?1,?2,?3,?4,?5,?6,?7,?8,?9,?10,?11,?12,?13,?14,?15,?16)";
        if(sqlite3_prepare_v2(database, addSql, -1, &addStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        /* param 1 (text): id
         param 2 (text): name
         param 3 (text): size
         param 4 (text): iconurl
         param 5 (text): lastmodified
         param 6 (text): filename
         param 7 (text): path
         param 8 (integer): 0
         param 9 (integer): 0
         param 10 (text): parentid
         param 11 (text): serviceurl
         param 12 (integer): 0
         param 13 (text): dropbox
         param 14 (text): createdbyid
         param 15 (text): createdbyname
         */
        
        sqlite3_bind_text(addStmt, 1, [item.itemId UTF8String],-1,SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [item.name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(addStmt, 3, item.totalBytes);
        sqlite3_bind_text(addStmt, 4, [item.icon UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 5, [item.lastModifiedDate timeIntervalSince1970]);
        sqlite3_bind_text(addStmt, 6, [item.filename UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 7, [item.path UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 8, item.isFolder);
        sqlite3_bind_int(addStmt, 9, item.isDeleted);
        sqlite3_bind_text(addStmt, 10, [item.parentId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 11, [item.serverUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 12, item.sourceId);
        sqlite3_bind_int(addStmt, 13, item.sourceType);
        sqlite3_bind_text(addStmt, 14, [item.createdById UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 15, [item.createdByName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 16, item.isShared);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
        {
            int errorCode = sqlite3_errcode(database);
            if (errorCode != NTXSQLITE_IOERR)
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(addStmt);
    }
    else
    {
        // Update
       
       // sqlite3_finalize(updateStmt);
    }
}

- (NSArray *) getItemsInFolder:(NSString*) folderId
{
    sqlite3_stmt * statement;
    
    const char * sql = "Select Id,Name,Size,IconUrl,LastModified,Filename,Path,IsFolder,IsDeleted,ParentId,ServerUrl,SourceId,SourceType,CreatedById,CreatedByName,IsShared from [Files] where [ParentId] = ?";
    
    
    if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(database));
        return nil;
    }
    
    sqlite3_bind_text(statement, 10, [folderId UTF8String], -1, SQLITE_TRANSIENT);
    
    // Fetch the rows
    NSMutableArray * items = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        /* param 1 (text): id
         param 2 (text): name
         param 3 (text): size
         param 4 (text): iconurl
         param 5 (text): lastmodified
         param 6 (text): filename
         param 7 (text): path
         param 8 (integer): 0
         param 9 (integer): 0
         param 10 (text): parentid
         param 11 (text): serviceurl
         param 12 (integer): 0
         param 13 (text): dropbox
         param 14 (text): createdbyid
         param 15 (text): createdbyname
         */
        // Get the details for the given form
        ELVStorageItem* item = [[ELVStorageItem alloc]init];
        item.itemId = [self getColumnText:statement index:0];
        item.name = [self getColumnText:statement index:1];
        item.size = [self getColumnText:statement index:2];
        item.icon = [self getColumnText:statement index:3];
        
        NSString * uniqueId = [[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)];
        cachedForm.formId = uniqueId;
        cachedForm.lastUpdated = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement, 2)];
        cachedForm.Name = [self getColumnText:statement index:3];
        cachedForm.formDescription = [[self getColumnText:statement index:4] stripHtml];
        cachedForm.Type=sqlite3_column_int(statement, 5);
        [items addObject:cachedForm];
    }
    
    sqlite3_finalize(statement);
    
    return items;
}

#pragma mark - AppSetting Methods
- (NSString *) getApplicationSettingByName:(NSString *)name
{
    NSString * setting = nil;
    sqlite3_stmt * statement;
    
    const char * sql = "select [Value] from [DbAppSettings] where [Name] = ?";
    
    if ([ELVDatabaseStorageHelper getDatabase])
    {
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
        {
            // Can't do this as it will crash app
            //NSAssert1(0, @"Error while creating fetch setting statement. '%s'", sqlite3_errmsg(database));
            return nil;
        }
        
        sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW)
            setting = [self getColumnText:statement index:0];
        
        sqlite3_finalize(statement);
    }
    
    return setting;
}

-(void)setApplicationSettingValue:(NSString*)value forSettingName:(NSString*)settingName
{
    // Don't allow insertion of null values into DB as this would make it hard to determine if it is there or not in the future
    if (value == nil)
        return ;
    
    NSString * currentValue = [self getApplicationSettingByName:settingName];
    
    const char * sql;
    
    if (currentValue == nil)
        sql = "insert into [DbAppSettings] ([Name], [Value]) Values(?, ?)";
    else
        sql = "update [DbAppSettings] set [Name] = ?, [Value] = ?";
    
    sqlite3_stmt * statement;
    if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert2(0, @"Error while creating add/update application setting statement. '%s' from sql '%s'", sqlite3_errmsg(database), sql);
        return ;
    }
    
    sqlite3_bind_text(statement, 1, [settingName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        NSAssert1(0, @"Error while adding data. '%s'", sqlite3_errmsg(database));
        return ;
    }
    
    sqlite3_finalize(statement);
    return ;
}

#pragma mark - Generic Methods

- (void) createDatabaseIfNeeded
{
	NSString * dbPath =[self.localStorageHelper getPathDatabase];
	BOOL success = [self.localStorageHelper fileExistsAtPath:dbPath];
	
	if(!success) {
        [self.localStorageHelper createFolder:ELVLocalStorageDataPath error:nil];
		[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"yekDrive.sqlite"];
	}
    
    const char *dbpath = [dbPath UTF8String];
    
    int sqliteThreadSafeCode = sqlite3_threadsafe();
    if (sqliteThreadSafeCode > 0)
    {
        int retCode = sqlite3_config(SQLITE_CONFIG_SERIALIZED);
        if (retCode != SQLITE_OK) // retCode == SQLITE_MISUSE is 21
            assert("database is not threadsafe enough!");
    }
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        //[database Set]
        
        char *errMsg;
        //App Setting
        const char * sql = "create table if not exists [DbAppSettings] ([Name] varchar not null collate nocase, [Value] varchar not null collate nocase)";
        if (sqlite3_exec(database, sql, NULL, NULL, &errMsg) != SQLITE_OK)
            NSAssert1(0, @"Failed to create DbAppSettings table. '%s'", sqlite3_errmsg(database));
        
        // Files
        const char *sql_stmt_files_table = "CREATE TABLE \"files\" (\"Id\" TEXT PRIMARY KEY  NOT NULL  UNIQUE , \"Name\" TEXT, \"Size\" NUMERIC, \"IconUrl\" TEXT, \"LastModified\" DATETIME, \"Filename\" TEXT, \"Path\" TEXT, \"IsFolder\" BOOL, \"IsDeleted\" BOOL, \"ParentId\" TEXT, \"ServerUrl\" TEXT, \"SourceId\" INTEGER, \"SourceType\" TEXT, \"Created\" DATETIME, \"CreatedById\" TEXT, \"CreatedByName\" TEXT, \"IsShared\" BOOL))";
        
        if (sqlite3_exec(database, sql_stmt_files_table, NULL, NULL, &errMsg) != SQLITE_OK)
            NSAssert1(0, @"Failed to create DbProfile table. '%s'", sqlite3_errmsg(database));
        
        /*const char *sql_stmt_table4 = "CREATE TABLE if not exists \"DbCachedSource\" (\"Id\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL, \"SourceId\" VARCHAR NOT NULL collate nocase, \"Name\" VARCHAR NOT NULL collate nocase, \"ProfileId\" INTEGER NOT NULL, \"Enabled\" BOOL)";
         
         if (sqlite3_exec(database, sql_stmt_table4, NULL, NULL, &errMsg) != SQLITE_OK)
         NSAssert1(0, @"Failed to create DbCachedSource table. '%s'", sqlite3_errmsg(database));
         */
    }
    else
    {
        NSAssert1(0, @"Failed to open/create database. '%s'", sqlite3_errmsg(database));
    }
}

#pragma mark - private methods

-(BOOL)doesColumnExists:(NSString *)table column:(NSString *)column
{
    BOOL columnExists = NO;
    
    sqlite3_stmt *selectStmt;
    
    NSString *sql = [NSString stringWithFormat: @"select %@ from %@", column, table];
    
    const char *sqlStatement = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    if(sqlite3_prepare_v2(database, sqlStatement, -1, &selectStmt, NULL) == SQLITE_OK)
        columnExists = YES;
    
    return columnExists;
}

-(void) createNewTableColumn:(NSString *)table column:(NSString *)column type:(NSString *)type
{
    if (![self doesColumnExists:table column:column])
    {
        NSLog(@"Create new Column");
        
        char *errMsg;
        
        NSString *sql = [NSString stringWithFormat: @"ALTER TABLE %@ ADD COLUMN %@ %@", table, column, type];
        
        const char *sqlStatement = [sql cStringUsingEncoding:NSASCIIStringEncoding];
        
        if ([ELVDatabaseStorageHelper getDatabase])
        {
            if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errMsg) != SQLITE_OK)
                NSAssert1(0, @"Failed to create a new table column. '%s'", sqlite3_errmsg(database));
        }
    }
}


-(NSString *)getColumnText:(sqlite3_stmt *)statement index:(int)index
{
    const unsigned char * dbVal = sqlite3_column_text(statement, index);
    if (dbVal == nil)
        return nil;
    return [NSString stringWithUTF8String:(char *)dbVal];
}



+(bool) getDatabase
{
    return (database != nil);
}

+(void) closeDatabase
{
    if (database != nil)
        sqlite3_close(database);
}


@end
