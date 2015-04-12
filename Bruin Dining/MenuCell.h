//
//  MenuCell.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 6/22/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MenuItem.h"
typedef enum StarState : NSUInteger {
    StarStateEmpty = 0,
    StarStateFull = 1,
} StarState;

@interface MenuCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *favButton;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, assign) BOOL isFavorited;
@property (nonatomic, retain) MenuItem *menuItem;

- (IBAction)registerFavorite:(id)sender;
-(void)changeStarToState:(StarState)state;
-(void)showFavoriteAlertIfNeeded;
@end
