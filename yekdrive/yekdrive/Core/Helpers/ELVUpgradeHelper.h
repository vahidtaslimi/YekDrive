//
//  NTXUpgradeHelper.h
//  Liberado
//
//  Created by Greg Richardson on 4/03/13.
//  Copyright (c) 2013 Nintex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTXDatabaseStorageHelper;
@class NTXLocalStorageHelper;

@interface NTXUpgradeHelper : NSObject

// ===== Version history =====
#define NTXVersion0_1 @"0.1"  // This version doesn't exist - just used for demonstration
#define NTXVersion0_2 @"0.2"  // This version doesn't exist - just used for demonstration
#define NTXVersion1_0 @"1.0"
#define NTXVersion1_1 @"1.1"
#define NTXVersion2_0 @"2.0"
#define NTXVersion2_2 @"2.2"
#define NTXVersion2_3 @"2.3"


// Public interfaces
- (id)init;

- (NSString *) getCurrentDatabaseVersion;

- (void) performUpgrades;


// ============================================================
// These are pulic only for unit testing - do not call directly

-(bool) performUpdateFrom0_1;
-(bool) performUpdateFrom0_2;
-(bool) performUpdateFrom1_0;
-(bool) performUpdateFrom1_1;

@end
