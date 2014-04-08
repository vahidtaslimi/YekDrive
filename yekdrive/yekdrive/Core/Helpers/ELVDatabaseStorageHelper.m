#import "ELVDatabaseStorageHelper.h"
#import <sqlite3.h>
#import "ELVStorageItem.h"
#import "ELVConstants.h"

static sqlite3 *database = nil;

@implementation ELVDatabaseStorageHelper

-(id)init{
    self=[super init];
    if(self)
    {
        self.localStorageHelper = [[ELVLocalStorageHelper alloc]init];
    }
    
    return self;
}
#pragma mark - Public Methods
-(NSString*)getApplicationSettingByName:(NSString*)settingName
{
    return @"string";
}
-(void)setApplicationSettingValue:(NSString*)value forSettingName:(NSString*)settingName
{
    
}

- (NSMutableArray *) getItemsInFolder:(NSString*)parentId
{
    return nil;
}

- (NSString *) getApplicationSetting:(NSString *)name
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

- (bool) setApplicationSetting:(NSString *)name value:(NSString *)value
{
    // Don't allow insertion of null values into DB as this would make it hard to determine if it is there or not in the future
    if (value == nil)
        return false;
    
    NSString * currentValue = [self getApplicationSetting:name];
    
    const char * sql;
    
    if (currentValue == nil)
        sql = "insert into [DbAppSettings] ([Name], [Value]) Values(?, ?)";
    else
        sql = "update [DbAppSettings] set [Name] = ?, [Value] = ?";
    
    sqlite3_stmt * statement;
    if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        NSAssert2(0, @"Error while creating add/update application setting statement. '%s' from sql '%s'", sqlite3_errmsg(database), sql);
        return false;
    }
    
    sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(statement))
    {
        NSAssert1(0, @"Error while adding data. '%s'", sqlite3_errmsg(database));
        return false;
    }
    
    sqlite3_finalize(statement);
    return true;
}


- (NSObject*) getInstance:(NSString*)sourceId itemId:(NSString*)itemId profileId:(int)profileId
{
   /*
	if ([NTXDatabaseStorageHelper getDatabase])
    {
		const char *getSql = "SELECT Id, FormId, ProfileId, SourceId, Type, Token, Json, DraftJson, State, LastUpdated, Name, Description, ErrorMessage, Submitting "
                            "FROM DbCachedFormInstance "
                            "WHERE ProfileId = ? and SourceId = ? and FormId = ?";
		sqlite3_stmt *getStmt;
        
		if(sqlite3_prepare_v2(database, getSql, -1, &getStmt, NULL) == SQLITE_OK) {
            
			sqlite3_bind_int(getStmt, 1, profileId);
            sqlite3_bind_text(getStmt, 2, [sourceId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(getStmt, 3, [itemId UTF8String], -1, SQLITE_TRANSIENT);
            
			while(sqlite3_step(getStmt) == SQLITE_ROW)
            {
                cachedFormInstance = [[NTXCachedFormInstance alloc] init];
                cachedFormInstance.instanceId = sqlite3_column_int(getStmt, 0);
                cachedFormInstance.formId = [self getColumnText:getStmt index:1];
                cachedFormInstance.profileId = sqlite3_column_int(getStmt, 2);
                cachedFormInstance.sourceId = [self getColumnText:getStmt index:3];
                cachedFormInstance.type = sqlite3_column_int(getStmt, 4);
                cachedFormInstance.token = [self getColumnText:getStmt index:5];
                cachedFormInstance.json = [self getColumnText:getStmt index:6];
                cachedFormInstance.draftJson = [self getColumnText:getStmt index:7];
                cachedFormInstance.state = sqlite3_column_int(getStmt, 8);
                cachedFormInstance.lastUpdated = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(getStmt, 9)];
                cachedFormInstance.name = [self getColumnText:getStmt index:10];
                cachedFormInstance.formDescription = [[self getColumnText:getStmt index:11] stripHtml];
                cachedFormInstance.errorMessage = [self getColumnText:getStmt index:12];
                cachedFormInstance.submitting = sqlite3_column_int(getStmt, 13);
			}
            
            sqlite3_finalize(getStmt);
		}
	}
    */
    return nil;
}

- (void) saveItemDefinition:(ELVStorageItem*)item
{
      /*  // Add
        sqlite3_stmt * addStmt;
        const char * addSql = "insert into DbCachedFormDefinition (ProfileId, FormId, SourceId, Type, Token, Json, LastUpdated) Values(?, ?, ?, ?, ?, ?, ?)";
        if(sqlite3_prepare_v2(database, addSql, -1, &addStmt, NULL) != SQLITE_OK)
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        
        sqlite3_bind_int(addStmt, 1, profileId);
        sqlite3_bind_text(addStmt, 2, [formId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 3, [sourceId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 4, itemType);
        sqlite3_bind_text(addStmt, 5, [[NSString empty] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 6, [requestResult.responseString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(addStmt, 7, [requestResult.lastModified timeIntervalSince1970]);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
        {
            int errorCode = sqlite3_errcode(database);
            if (errorCode != NTXSQLITE_IOERR)
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_finalize(addStmt);
 */
}


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
        const char *sql_stmt_files_table = "CREATE TABLE \"files\" (\"Id\" TEXT PRIMARY KEY  NOT NULL  UNIQUE , \"Name\" TEXT, \"Size\" NUMERIC, \"IconUrl\" TEXT, \"LastModified\" DATETIME, \"Filename\" TEXT, \"Path\" TEXT, \"IsFolder\" BOOL, \"IsDeleted\" BOOL, \"ParentId\" TEXT, \"ServerUrl\" TEXT, \"SourceId\" INTEGER, \"SourceType\" TEXT, \"Created\" DATETIME, \"CreatedById\" TEXT, \"CreatedByName\" TEXT)";
        
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
