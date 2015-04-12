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
    
    if (!_isFavorited){
        [self.menuItem saveToDatabase];
    } else {
        [self.menuItem removeFromDatabase];
    }
    
    [self.menuItem toggleFavorites];
    self.isFavorited = !self.isFavorited;
 
    [self showFavoriteAlertIfNeededForFood:_name.text];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:false] forKey:@"needsFavoriteTutorial"];
}

- (void)setIsFavorited:(BOOL)isFavorited {
    _isFavorited = isFavorited;
    NSString *imgName = isFavorited ? @"star_filled.png" : @"star_empty.png";
    [self.favButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)setMenuItem:(MenuItem *)menuItem {
    _menuItem = menuItem;
    _name.text = menuItem.name;
    [_menuItem toggleFavoritesIfNeeded];
    
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

-  (void) showFavoriteAlertIfNeededForFood:(NSString*)name {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL shouldSet = [[defaults objectForKey:@"needsFavoriteTutorial"] boolValue];
    if (shouldSet) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200/4, 282/4)];
        UIImage *swipeImage = [UIImage imageNamed:@"star_filled.png"];
        
        
        CGSize scaleSize = CGSizeMake(200/4, 282/7);
        UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
        [swipeImage drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
        UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        imageView.contentMode=UIViewContentModeCenter;
        [imageView setImage:resizedImage];
        
        NSString *alertMessage = [NSString stringWithFormat:@"Now you'll receive a push notification if %@ reappears on the menu.", name];
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Tutorial"
                                                         message:alertMessage
                                                        delegate:self
                                               cancelButtonTitle:@"Got it!"
                                               otherButtonTitles: nil];
        [alert setValue:imageView forKey:@"accessoryView"];
        [alert show];
    }
}
@end
