//
//  MenuTable.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 4/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiningHall.h"
#import "MenuLoader.h"
#import "MenuCell.h"

@interface MenuTableController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    Meal *currentMenu;
    Specificity currentSpec;
    
}

@property (nonatomic, retain) NSMutableDictionary *menuList;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UISegmentedControl* hallPicker;
@property (nonatomic, retain) IBOutlet UISegmentedControl* specificPicker; //curently removed from storyboard
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *hallName;
@property (nonatomic, retain) NSString *currentMeal;
- (void) switchSpecific;
- (void) switchHall;
@end
