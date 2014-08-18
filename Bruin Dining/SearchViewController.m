//
//  SearchViewController.m
//  Bruin Dining
//
//  Created by William Gu on 8/6/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "SearchViewController.h"
#import "MenuCell.h"
#import "MenuItem.h"
#import "DiningHall.h"
#import "Station.h"
#import "MenuLoader.h"

@interface SearchViewController ()

@end


@implementation SearchViewController



#pragma mark- Helper Methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //We'll search through the data here once you give me data to use
    // NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"string CONTAINS[c] %@", searchText];
    
    NSString *predicateFormat = @"%K CONTAINS[cd] %@";
    NSString *searchAttribute = @"name";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
    
    //BEGINSWITH, ENDSWITH LIKE MATCHES CONTAINS
    _searchResults = [_allFoodData filteredArrayUsingPredicate:predicate];
    //self.searchResults = [[NSArray alloc] initWithArray:[_allFoodData filteredArrayUsingPredicate:resultPredicate]];
    
    
}


#pragma mark- Table View Delegate Methods




#pragma mark- Table DATA Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; //default
}


-(IBAction)test:(id)sender
{
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_searchResults count];
    }
    else
    {
        NSLog(@"COUNT ROWS: %lu", (unsigned long)[self.allFoodData count]);
        return [self.allFoodData count];
    }
    
    // return 10; //INCOMPLETE FOR NOW
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    //old way
    static NSString *identifier = @"TVWGCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSLog(@"Making new menucell!");
        //cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
 */
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (cell == nil){
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
    
    //When you give me food data we can load it here, we can display random foods for now but I'm not sure how to fetch that data using your API.
    MenuItem* food;
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        food = [_searchResults objectAtIndex:indexPath.row];
    }
    else{
        food= [self.allFoodData objectAtIndex:indexPath.row];
    }
    
    cell.foodLabel.text= food.name;
    if (food.isVegetarian || food.isVegan)
        cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green:100/255.0f blue:0/255.0f alpha:1]; //possibly distinguish vegetarian and vegan later
    
    return cell;
}

#pragma mark - Search Bar Delegate Methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}



#pragma mark - Search DISPLAY Delegate Methods


-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //calls our search function
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

/*
 -(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
 {
 
 return NO;
 }
 */

#pragma mark -  Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _allFoodData = [NSMutableArray array];
    //fills allFoodData with MenuItem objects
    [self addFoodsToArray:_allFoodData];
    
}

- (void) addFoodsToArray:(NSMutableArray*)targetArray {
    
    PFQuery * foodQuery = [PFQuery queryWithClassName:@"Food"];
    
    [foodQuery findObjectsInBackgroundWithBlock:^(NSArray * foods, NSError * error) {
        if (error) {
            NSLog(@"ERROR");
        } else {
            for (PFObject *foodRaw in foods) {
                MenuItem *food = [[MenuItem alloc] initWithName:[foodRaw valueForKey:@"name"]  andURL:nil];
                [targetArray addObject:food];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void) hideViews {
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end