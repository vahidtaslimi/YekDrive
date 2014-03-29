//
//  ELVAppDelegate.h
//  yekdrive
//
//  Created by VT on 29/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface ELVAppDelegate : UIResponder <UIApplicationDelegate,DBSessionDelegate, DBNetworkRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIViewController *rootViewController;

@end
