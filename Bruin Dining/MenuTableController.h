//
//  MenuTable.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 4/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Meal.h"
#import "MenuLoader.h"
#import "MenuCell.h"
#import "HMSegmentedControl.h"
#import "Reachability.h"
#import <iAd/iAd.h>

@interface MenuTableController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    Meal *currentMenu;
    Specificity currentSpec;
    BOOL preferencesShowing;
    BOOL menuIsLoading;
    CGPoint initialTablePosition;

}
@property (nonatomic, retain) IBOutlet ADBannerView *banner;
@property (nonatomic, retain) NSMutableDictionary *menuList;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet HMSegmentedControl *hallSelector;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *hallName;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

@property (nonatomic, retain) IBOutlet UISwitch *vegSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *summarySwitch;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *preferencesButton;

@property (nonatomic, retain) IBOutlet UILabel *vegLabel;
@property (nonatomic, retain) IBOutlet UILabel *summaryLabel;
@property (nonatomic, retain) IBOutlet UIButton *hideSettingsButton;

@property (nonatomic, retain) IBOutlet UIView *tutorial;
@property (nonatomic, assign) MealType currentMeal;
- (void) switchSpecific;
- (void) switchHall;
- (IBAction)togglePreferencePageVisibility:(id)sender;
- (IBAction)changeVegPref:(id)sender;
- (IBAction)changeSummaryPref:(id)sender;
- (BOOL)preferencesVisible;

@end
