//
//  ELVFilesListingVC.m
//  yekdrive
//
//  Created by VT on 30/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVFilesListingVC.h"
#import "ELVFilesViewModel.h"
#import "ELVStorageItem.h"
#import "ELVIOnlineStorageRepository.h"
#import "ELVDropboxRepository.h"
#import "NSObject+NTXObjectExtensions.h"
#import "ELVFileCell.h"
#import "ELVFolderCell.h"

static NSString *ELVFileListingVCDropboxKvoContext = @"ELVFileListingVCDropboxKvoContext";

@interface ELVFilesListingVC ()

@end

@implementation ELVFilesListingVC
{
    ELVFilesViewModel* _dataContext;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        id<ELVIOnlineStorageRepository> dropboxRepo=[[ELVDropboxRepository alloc]init];
        _dataContext=[[ELVFilesViewModel alloc]initWithParameters:dropboxRepo];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBindings];
    
    [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    if (_dataContext != nil)
    {
        [self removeBindings];
    }
}

#pragma mark - DataContext
-(void) load
{
    [_dataContext loadItems];
}

#pragma mark - Binding section

- (void) removeBindings
{
    [_dataContext removeObserverSafely:self forKeyPath:@"items" context:&ELVFileListingVCDropboxKvoContext];
}

- (void) setupBindings
{
    [_dataContext addObserver:self forKeyPath:@"items" options:NSKeyValueObservingOptionNew context:&ELVFileListingVCDropboxKvoContext];
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqual:@"items"])
    {
        if ([change objectForKey:NSKeyValueChangeNewKey] == [NSNull null])
        {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.tableView reloadData];
        });
    }
    else if ([keyPath isEqual:@"form.isValid"])
    {
        
    }
    else if ([keyPath isEqual:@"isProgressVisible"])
    {
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataContext.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ELVStorageItem* item=_dataContext.items[indexPath.row];
    if(item.isFolder)
    {
        ELVFolderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"foldercell" forIndexPath:indexPath];
        cell.nameLabel.text=item.name;
        
        return cell;
    }
    else
    {
        ELVFileCell*     cell = [tableView dequeueReusableCellWithIdentifier:@"filecell" forIndexPath:indexPath];
        cell.nameLabel.text=item.name;
        return cell;
    }
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
