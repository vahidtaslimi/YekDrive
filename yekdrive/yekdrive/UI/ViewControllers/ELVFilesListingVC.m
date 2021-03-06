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
#import "IELVOnlineStorageRepository.h"
#import "ELVDropboxRepository.h"
#import "NSObject+NTXObjectExtensions.h"
#import "ELVFileCell.h"
#import "ELVFolderCell.h"
#import "ELVFileViewVC.h"
#import "ElVOneDriveRepository.h"
#import <Objection-iOS/Objection.h>

static NSString *ELVFileListingVCDropboxKvoContext = @"ELVFileListingVCDropboxKvoContext";

@interface ELVFilesListingVC ()

@end

@implementation ELVFilesListingVC
{
    ELVFilesViewModel* _dataContext;
    ELVStorageItem* _currentItem;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
         self.dataContext=[[JSObjection defaultInjector]getObject:[ELVFilesViewModel class]];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBindings];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(load) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
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
    [_dataContext loadItemsInFolder:_currentItem];
}

#pragma mark - Binding section

- (void) removeBindings
{
    [_dataContext removeObserverSafely:self forKeyPath:@"items" context:&ELVFileListingVCDropboxKvoContext];
    //  [_dataContext removeObserverSafely:self forKeyPath:@"lastDownloadedFilename" context:&ELVFileListingVCDropboxKvoContext];
    //[_dataContext removeObserverSafely:self forKeyPath:@"downloadProgress" context:&ELVFileListingVCDropboxKvoContext];
    
}

- (void) setupBindings
{
    [_dataContext addObserver:self forKeyPath:@"items" options:NSKeyValueObservingOptionNew context:&ELVFileListingVCDropboxKvoContext];
    // [_dataContext addObserver:self forKeyPath:@"lastDownloadedFilename" options:NSKeyValueObservingOptionNew context:&ELVFileListingVCDropboxKvoContext];
    //[_dataContext addObserver:self forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:&ELVFileListingVCDropboxKvoContext];
    
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
            [self.refreshControl endRefreshing];
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
        cell.rowIndex = indexPath.row;
        return cell;
    }
    else
    {
        ELVFileCell*     cell = [tableView dequeueReusableCellWithIdentifier:@"filecell" forIndexPath:indexPath];
        cell.nameLabel.text=item.name;
        cell.rowIndex = indexPath.row;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentItem= [_dataContext.items objectAtIndex:indexPath.row];
    if(_currentItem.isFolder)
        [self load];
}



- (IBAction)upButtonHandler:(id)sender {
    if(_currentItem == nil)
        return;
    _currentItem =_currentItem.parent;
    [self load];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"viewfile"])
    {
        ELVFileCell* cell = sender;
        ELVFileViewVC* vc=   (ELVFileViewVC*)[segue destinationViewController];
        vc.dataContext = _dataContext;
        vc.item =[_dataContext.items objectAtIndex:cell.rowIndex];
    }
}
@end
