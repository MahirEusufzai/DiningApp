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
    static NSString *identifier = @"TVWGCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSLog(@"Making new menucell!");
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    //When you give me food data we can load it here, we can display random foods for now but I'm not sure how to fetch that data using your API.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text= [_searchResults objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [self.allFoodData objectAtIndex:indexPath.row];
    }
    
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
    // Do any additional setup after loading the view.
    
    
    //FOR TESTING: Loading a fake array of data
    /*
    MenuItem *item0 = [[MenuItem alloc] initWithName:@"Eggs" andURL:nil];
    MenuItem *item1 = [[MenuItem alloc] initWithName:@"Ham" andURL:nil];
    MenuItem *item2 = [[MenuItem alloc] initWithName:@"Fruit" andURL:nil];
    MenuItem *item3 = [[MenuItem alloc] initWithName:@"Burger" andURL:nil];
    MenuItem *item4 = [[MenuItem alloc] initWithName:@"Panakes" andURL:nil];
    
    _allFoodData = [[NSMutableArray alloc]init];
    
    [_allFoodData addObject:item0];
    [_allFoodData addObject:item1];
    [_allFoodData addObject:item2];
    [_allFoodData addObject:item3];
    [_allFoodData addObject:item4];
     */
    _allFoodData = [[NSMutableArray alloc] initWithArray:@[@"Eggs",@"Ham",@"Fruit",@"Burger",@"Pancakes",@"Yum"]];
    
    
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