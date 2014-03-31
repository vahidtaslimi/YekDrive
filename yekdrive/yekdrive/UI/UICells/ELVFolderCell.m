//
//  ELVFolderCell.m
//  yekdrive
//
//  Created by VT on 31/03/2014.
//  Copyright (c) 2014 Elvun. All rights reserved.
//

#import "ELVFolderCell.h"

@implementation ELVFolderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
