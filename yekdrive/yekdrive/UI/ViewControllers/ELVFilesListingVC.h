//
//  ELVFilesListingVC.h
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELVFilesViewModel.h"

@interface ELVFilesListingVC : UITableViewController

@property ELVFilesViewModel* dataContext;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *upButton;

- (IBAction)upButtonHandler:(id)sender;

@end
