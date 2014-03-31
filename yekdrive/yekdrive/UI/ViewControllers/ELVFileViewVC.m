//
//  ELVFileViewVC.m
//  yekdrive
//
//  Created by VT on 1/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVFileViewVC.h"
#import "NSObject+NTXObjectExtensions.h"

@interface ELVFileViewVC ()

@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@end

static NSString *ELVFileViewKvoContext = @"ELVFileViewVCKvoContext";

@implementation ELVFileViewVC

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
    [self setupBindings];
    [self.dataContext openItem:self.item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openFile
{
    
    NSURL *fileURL =[[NSURL alloc]initFileURLWithPath:[self.item getLocalPath]];
    //fileURL = [self.documentURLs objectAtIndex:indexPath.row];
    
    [self setupDocumentControllerWithURL:fileURL];
    [self.docInteractionController presentPreviewAnimated:YES];
    
    
    /*
     // for case 3 we use the QuickLook APIs directly to preview the document -
     QLPreviewController *previewController = [[QLPreviewController alloc] init];
     previewController.dataSource = self;
     previewController.delegate = self;
     
     // start previewing the document at the current section index
     previewController.currentPreviewItemIndex = 0;
     [[self navigationController] pushViewController:previewController animated:YES];
     */
}

- (void) dealloc
{
    if (self.dataContext != nil)
    {
        [self removeBindings];
    }
}

#pragma mark - Binding section

- (void) removeBindings
{
    
    [self.dataContext removeObserverSafely:self forKeyPath:@"lastDownloadedFilename" context:&ELVFileViewKvoContext];
    [self.dataContext  removeObserverSafely:self forKeyPath:@"downloadProgress" context:&ELVFileViewKvoContext];
    
}

- (void) setupBindings
{
    [_dataContext addObserver:self forKeyPath:@"lastDownloadedFilename" options:NSKeyValueObservingOptionNew context:&ELVFileViewKvoContext];
    [_dataContext addObserver:self forKeyPath:@"downloadProgress" options:NSKeyValueObservingOptionNew context:&ELVFileViewKvoContext];
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqual:@"lastDownloadedFilename"])
    {
        [self openFile];
    }
    else if ([keyPath isEqual:@"downloadProgress"])
    {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.navigationItem.title = [NSString stringWithFormat:@"%f", self.dataContext.downloadProgress];
        });
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

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
    /* NSInteger numToPreview = 0;
     
     NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
     if (selectedIndexPath.section == 0)
     numToPreview = NUM_DOCS;
     else
     numToPreview = self.documentURLs.count;
     
     return numToPreview;*/
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
    
    return fileURL;
}
@end
