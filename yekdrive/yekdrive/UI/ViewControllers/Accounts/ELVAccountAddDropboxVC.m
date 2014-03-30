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
        [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initiateLinking {
    if (![[DBSession sharedSession] isLinked]) {

		[[DBSession sharedSession] linkFromController:self];
    }
}

- (void)removeLinking {
        [[DBSession sharedSession] unlinkAll];
        [[self navigationController] popToRootViewControllerAnimated:YES];
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

- (IBAction)removeButton:(id)sender {
    [self removeLinking];
}
@end
