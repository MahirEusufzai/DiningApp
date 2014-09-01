//
//  SettingsCellTableViewCell.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 8/23/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
