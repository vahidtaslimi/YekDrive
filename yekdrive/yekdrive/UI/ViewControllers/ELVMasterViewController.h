//
//  ELVMasterViewController.h
//  yekdrive
//
//  Created by VT on 29/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELVDetailViewController;

@interface ELVMasterViewController : UITableViewController

@property (strong, nonatomic) ELVDetailViewController *detailViewController;

@end
