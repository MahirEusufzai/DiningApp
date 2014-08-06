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

@property (nonatomic, strong) NSArray* allFoodData;

@end

@implementation SearchViewController
{
    NSArray* searchResults;
}

#pragma mark- Helper Methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //We'll search through the data here once you give me data to use
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    //BEGINSWITH, ENDSWITH LIKE MATCHES CONTAINS
    //searchResults = [_allFoodData filteredArrayUsingPredicate:resultPredicate];
  //  self.searchResults = [[NSArray alloc] initWithArray:[_allFoodData filteredArrayUsingPredicate:resultPredicate]];
    
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
       return [searchResults count];
            
    }
    else
    {
        return [self.allFoodData count];
    }
    
   // return 10; //INCOMPLETE FOR NOW
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TVWGCell";
    //MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSLog(@"Making new menucell!");
        //cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    //When you give me food data we can load it here, we can display random foods for now but I'm not sure how to fetch that data using your API.
    MenuItem* food =  [[MenuItem alloc] initWithName:[NSString stringWithFormat:@"%ld#row!",(long)indexPath.row] andURL:@"www.google.com"];

    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        food.name = [searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        food.name = [self.allFoodData objectAtIndex:indexPath.row];
    }
    
    
    
   
    
    cell.textLabel.text = food.name;
    if (food.isVegetarian || food.isVegan)
        cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green:100/255.0f blue:0/255.0f alpha:1]; //possibly distinguish vegetarian and vegan later
    

    
    return cell;
}

#pragma mark - Search Bar Delegate Methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
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
    _allFoodData = [[NSMutableArray alloc] initWithArray:@[@"Eggs",@"Ham",@"Fruit",@"Burger",@"Pancakes",@"Yum"]];
    

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
