//
//  MenuCell.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 6/22/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MenuCell.h"

const int NORMAL_NAME_LENGTH = 30;
@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.name.font = [UIFont fontWithName:@"Arial" size:12];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)registerFavorite:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:false] forKey:@"needsFavoriteTutorial"];
    

    if (!_isFavorited){
        [self.menuItem saveToDatabase];
    } else {
        [self.menuItem removeFromDatabase];
    }
    
    [self.menuItem toggleFavorites];
    self.isFavorited = !self.isFavorited;
 
}

- (void)setIsFavorited:(BOOL)isFavorited {
    _isFavorited = isFavorited;
    NSString *imgName = isFavorited ? @"star_filled.png" : @"star_empty.png";
    [self.favButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)setMenuItem:(MenuItem *)menuItem {
    _menuItem = menuItem;
    _name.text = menuItem.name;
    
    if (menuItem.name.length > NORMAL_NAME_LENGTH) {
        _name.font = [[_name font] fontWithSize:13];
    }
    else {
        _name.font = [[_name font] fontWithSize:15];
    }
    
    if (menuItem.isVegetarian || menuItem.isVegan){
        _name.textColor = [UIColor colorWithRed:0/255.0f green:100/255.0f blue:0/255.0f alpha:1]; //possibly distinguish vegetarian and vegan later
    }
    else {
        _name.textColor = [UIColor darkGrayColor];
    }
    
    [self setIsFavorited:menuItem.isFavorite];
}
@end
