//
//  ELVAccountAddOneDriveVC.m
//  yekdrive
//
//  Created by VT on 1/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVAccountAddOneDriveVC.h"

@interface ELVAccountAddOneDriveVC ()

@end

static NSString * const CLIENT_ID = @"0000000048116F88";

@implementation ELVAccountAddOneDriveVC
{
@private NSArray *_scopes;
    LiveConnectClient* _liveClient;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //http://msdn.microsoft.com/en-us/library/live/hh243646.aspx
        _scopes = [NSArray arrayWithObjects:
                   @"wl.signin",
                   @"wl.basic",
                   @"wl.skydrive",
                   @"wl.skydrive_update",
                   @"wl.contacts_skydrive",
                   @"wl.offline_access", nil];
        _liveClient = [[LiveConnectClient alloc] initWithClientId:CLIENT_ID
                                                           scopes:_scopes
                                                         delegate:self];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self signin];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signin {
    if (_liveClient.session == nil)
    {
        [_liveClient login:self
                    scopes:_scopes
                  delegate:self];
    }
    else
    {
    }
}

- (IBAction)signOutButtonHandler:(id)sender {
    
    [_liveClient logoutWithDelegate:self
                          userState:@"logout"];
}

#pragma mark LiveAuthDelegate

- (void) updateUI {
    LiveConnectSession *session = _liveClient.session;
    if (session == nil) {
        // [self.signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
        // self.viewPhotosButton.hidden = YES;
        //self.userInfoLabel.text = @"Sign in with a Microsoft account before you can view your SkyDrive photos.";
        // self.userImage.image = nil;
    }
    else {
        //[self.signInButton setTitle:@"Sign out" forState:UIControlStateNormal];
        // self.viewPhotosButton.hidden = NO;
        //self.userInfoLabel.text = @"";
        
       // [_liveClient getWithPath:@"me" delegate:self userState:@"me"];
       // [_liveClient getWithPath:@"me/picture" delegate:self userState:@"me-picture"];
    }
}

- (void) authCompleted: (LiveConnectSessionStatus) status
               session: (LiveConnectSession *) session
             userState: (id) userState {
    [self updateUI];
}

- (void) authFailed: (NSError *) error
          userState: (id)userState {
    // Handle error here
}

#pragma mark LiveOperationDelegate

- (void) liveOperationSucceeded:(LiveOperation *)operation {
    if ([operation.userState isEqual:@"me"]) {
        NSDictionary *result = operation.result;
        id name = [result objectForKey:@"name"];
        
        //self.userInfoLabel.text = (name != nil)? name : @"";
    }
    
    if ([operation.userState isEqual:@"me-picture"]) {
        NSString *location = [operation.result objectForKey:@"location"];
        if (location) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:location]];
            // self.userImage.image = [UIImage imageWithData:data];
        }
    }
}

- (void) liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    // Handle error here.
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
