//
//  MenuTable.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 4/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MenuTableController.h"

@interface MenuTableController ()

@end

@implementation MenuTableController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.hallPicker addTarget:self action:@selector(switchHall) forControlEvents:UIControlEventValueChanged];
    
    [self.specificPicker addTarget:self action:@selector(switchSpecific) forControlEvents:UIControlEventValueChanged];
   
    currentSpec = specificitySummary;
    [self setCurrentMenu];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.hallPicker titleForSegmentAtIndex:self.hallPicker.selectedSegmentIndex];
    Station *s = [currentMenu getStation:section ForHall:key];
    return s.foodList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *key = [self.hallPicker titleForSegmentAtIndex:self.hallPicker.selectedSegmentIndex];
    DiningHall *d = [currentMenu.hallList valueForKey:key];
    return d.stationList.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *key = [self.hallPicker titleForSegmentAtIndex:self.hallPicker.selectedSegmentIndex];
    Station *s = [currentMenu getStation:section ForHall:key];
    return s.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (cell == nil)
        cell = (MenuCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    NSString *key = [self.hallPicker titleForSegmentAtIndex:self.hallPicker.selectedSegmentIndex];
    Station *s = [currentMenu getStation:indexPath.section ForHall:key];
    MenuItem* food = [s.foodList objectAtIndex:indexPath.row];
  
    cell.foodLabel.text = food.name;
    cell.foodLabel.font = [UIFont systemFontOfSize:14];
   
    if (food.isVegetarian)
        cell.foodLabel.textColor = [UIColor greenColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    view.tintColor = [UIColor colorWithRed:41/255.0f green:128/255.0f blue:185/255.0f alpha:1];
    // if you have index/header text in your tableview change your index text color
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    [headerIndexText.textLabel setTextColor:[UIColor whiteColor]];
    
}

#pragma mark -- segmented control
- (void)switchHall {

    [self.table reloadData];
}


- (void)switchSpecific {
   //loads new page data if necessary
    
    Specificity old = currentSpec;
    currentSpec = (Specificity)(self.specificPicker.selectedSegmentIndex);
    
    if (old != currentSpec)
        [self setCurrentMenu];
}

# pragma mark -- helper functions
- (void) setCurrentMenu {

    self.table.hidden=YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        MenuLoader *mL = [[MenuLoader alloc] init];
        currentMenu = [mL loadDiningDataForMeal:self.currentMeal Specificity:currentSpec];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.spinner stopAnimating];
            self.table.hidden = NO;
            [self.table reloadData];
            
        });
    });
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
