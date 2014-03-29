//
//  ELVDetailViewController.h
//  yekdrive
//
//  Created by VT on 29/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELVDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
