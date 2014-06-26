//
//  MenuCell.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 6/22/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MenuCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *favButton;
@property (nonatomic, retain) IBOutlet UILabel *foodLabel;

- (IBAction)registerFavorite:(id)sender;

@end
