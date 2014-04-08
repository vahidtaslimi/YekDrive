//
//  IELVDatabaseStorageHelper.h
//  yekdrive
//
//  Created by VT on 8/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IELVDatabaseStorageHelper <NSObject>

- (void) createDatabaseIfNeeded;
+ (void) closeDatabase;
-(void) createNewTableColumn:(NSString *)table column:(NSString *)column type:(NSString *)type;
- (NSMutableArray *) getItemsInFolder:(NSString*)parentId;
-(NSString*)getApplicationSettingByName:(NSString*)settingName;
-(void)setApplicationSettingValue:(NSString*)value forSettingName:(NSString*)settingName;

@end
