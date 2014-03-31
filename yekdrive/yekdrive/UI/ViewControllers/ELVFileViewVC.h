//
//  ELVFileViewVC.h
//  yekdrive
//
//  Created by VT on 1/04/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "ELVFilesViewModel.h"

@interface ELVFileViewVC : UIViewController<QLPreviewControllerDataSource,
QLPreviewControllerDelegate,
UIDocumentInteractionControllerDelegate>
@property  ELVFilesViewModel* dataContext;
@property ELVStorageItem* item;

@end
