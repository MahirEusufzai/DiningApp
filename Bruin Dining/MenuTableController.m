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
   
    
    currentSpec = specificitySummary;
    [self setCurrentMenu];
    
    [self.specificPicker addTarget:self action:@selector(switchSpecific) forControlEvents:UIControlEventValueChanged];


    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key =  [self.hallSelector.sectionTitles objectAtIndex:self.hallSelector.selectedSegmentIndex];
    //NSString *key = [self.hallPicker titleForSegmentAtIndex:self.hallPicker.selectedSegmentIndex];
    Station *s = [currentMenu getStation:section ForHall:key];
    return s.foodList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *key =  [self.hallSelector.sectionTitles objectAtIndex:self.hallSelector.selectedSegmentIndex];
    DiningHall *d = [currentMenu.hallList valueForKey:key];
    return d.stationList.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *key =  [self.hallSelector.sectionTitles objectAtIndex:self.hallSelector.selectedSegmentIndex];
    Station *s = [currentMenu getStation:section ForHall:key];
    return s.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (cell == nil)
        cell = (MenuCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    NSString *key =  [self.hallSelector.sectionTitles objectAtIndex:self.hallSelector.selectedSegmentIndex];
    Station *s = [currentMenu getStation:indexPath.section ForHall:key];
    MenuItem* food = [s.foodList objectAtIndex:indexPath.row];
  
    cell.foodLabel.text = food.name;
  //  cell.foodLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:12];

    if (food.isVegetarian || food.isVegan)
        cell.foodLabel.textColor = [UIColor colorWithRed:0/255.0f green:100/255.0f blue:0/255.0f alpha:1]; //possibly distinguish vegetarian and vegan later

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    view.tintColor = [UIColor colorWithRed:233/255.0f green:181/255.0f blue:41/255.0f alpha:1];
    // if you have index/header text in your tableview change your index text color
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    [headerIndexText.textLabel setTextColor:[UIColor blackColor]];
    [headerIndexText.textLabel setFont: [UIFont fontWithName:@"Helvetica Light" size:14]];

    
}

#pragma mark -- segmented control
- (void)switchHall {
   
    self.hallName.text = [self.hallSelector.sectionTitles objectAtIndex:self.hallSelector.selectedSegmentIndex];

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
            [self setHours];
            [self.table reloadData];

           
        });
    });
    
}

-(void) setHours {
    
    NSArray *halls = [currentMenu.hallList allValues];
    NSMutableArray *hallNames = [NSMutableArray array];
    NSMutableArray *hallImages = [NSMutableArray array];
    UIImage *open = [UIImage imageNamed:@"open.png"];
    UIImage *closed = [UIImage imageNamed:@"closed.png"];

    for (DiningHall* hall in halls){
         [hallNames addObject:hall.name];
        [hallImages addObject:(hall.isOpen ? open :closed)];
    
    }

     self.hallSelector.sectionTitles = hallNames;
    self.hallSelector.type = HMSegmentedControlTypeTextImages;
    self.hallSelector.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.hallSelector.font = [UIFont fontWithName:@"Helvetica Light" size:14];
    self.hallSelector.backgroundColor = [UIColor colorWithRed:233/256.0 green:233/256.0 blue:233/256.0  alpha:1];
    
    self.hallSelector.sectionImages =  hallImages;
    self.hallSelector.sectionSelectedImages = self.hallSelector.sectionImages;
    self.hallSelector.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    [self.hallSelector addTarget:self action:@selector(switchHall) forControlEvents:UIControlEventValueChanged];
    
    self.hallName.text = [self.hallSelector.sectionTitles objectAtIndex:self.hallSelector.selectedSegmentIndex];
    [self.hallSelector setNeedsDisplay];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
