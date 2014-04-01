//
//  ELVAccountAddOneDriveVC.h
//  yekdrive
//
//  Created by VT on 1/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveSDK/LiveConnectClient.h"

@interface ELVAccountAddOneDriveVC : UIViewController<LiveAuthDelegate, LiveOperationDelegate>

- (IBAction)signOutButtonHandler:(id)sender;


@end
