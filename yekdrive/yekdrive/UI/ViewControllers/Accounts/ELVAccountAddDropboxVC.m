//
//  ELVAccountAddDropboxVC.m
//  yekdrive
//
//  Created by VT on 29/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVAccountAddDropboxVC.h"
#import <DropboxSDK/DropboxSDK.h>


@interface ELVAccountAddDropboxVC ()

@end

@implementation ELVAccountAddDropboxVC
{
    bool isLoaded;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isLoaded)
    {
        isLoaded=true;
     [self initiateLinking];
    }
    else
        [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initiateLinking {
    if (![[DBSession sharedSession] isLinked]) {
		[[DBSession sharedSession] linkFromController:self];
    } else {
        [[DBSession sharedSession] unlinkAll];
        [[[UIAlertView alloc]
           initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
         show];
        //[self updateButtons];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
