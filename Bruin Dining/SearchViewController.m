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


-(void)viewWillAppear:(BOOL)animated {
    //added in case user changes favorites in edit screen and returns to this vc
    [_table reloadData];
}
#pragma mark- Helper Methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSString *predicateFormat = @"%K CONTAINS[cd] %@";
    NSString *searchAttribute = @"name";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
    
    //BEGINSWITH, ENDSWITH LIKE MATCHES CONTAINS
    _searchResults = [_allFoodData filteredArrayUsingPredicate:predicate];
  
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [_searchResults count];
    }
    else{
        return [self.allFoodData count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell = (MenuCell *)[nib objectAtIndex:0];
    }
    MenuItem* food = (tableView == self.searchDisplayController.searchResultsTableView) ? [_searchResults objectAtIndex:indexPath.row] : [self.allFoodData objectAtIndex:indexPath.row] ;
    cell.menuItem = food; //cell updates UI based on data
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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
    [self.view addSubview:_spinner];
    
    
    UINib *cellNIB = [UINib nibWithNibName:@"MenuCell" bundle:[NSBundle mainBundle]];
    [self.searchDisplayController.searchResultsTableView registerNib:cellNIB forCellReuseIdentifier:@"MenuCell"];
    
    _allFoodData = [NSMutableArray array];
    //fills allFoodData with MenuItem objects
    [self addFoodsToArray:_allFoodData];
    [self showFavoriteTutorialIfNeeded];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:false] forKey:@"needsSearchTutorial"];
}

- (void) showFavoriteTutorialIfNeeded {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL shouldSet = [[defaults objectForKey:@"needsSearchTutorial"] boolValue];
    if (shouldSet) {
        //ios7
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Tutorial"
                                                         message:@"Search for favorite foods here. You'll receive push alerts when they reappear on the menu."
                                                        delegate:self
                                               cancelButtonTitle:@"Got it!"
                                               otherButtonTitles: nil];
        [alert show];
        //ios8
    }
}

- (void) addFoodsToArray:(NSMutableArray*)targetArray {
    
    _spinner.hidden = NO;
    _spinner.center = self.view.center;
    [_spinner startAnimating];
    
    PFQuery * foodQuery = [PFQuery queryWithClassName:@"Food"];
    [foodQuery orderByAscending:@"name"];
    foodQuery.limit = 1000;
    [foodQuery findObjectsInBackgroundWithBlock:^(NSArray * foods, NSError * error) {
        if (error) {
        } else {
            for (PFObject *foodRaw in foods) {
                MenuItem *food = [[MenuItem alloc] initWithName:[foodRaw valueForKey:@"name"]  andURL:nil];
                [targetArray addObject:food];
            }
            [_spinner stopAnimating];
            [self.tableView reloadData];

        }
    }];
}

/*
- (NSArray*) allFoods {
    
    NSMutableArray *foodArr = [NSMutableArray array];
    PFQuery * foodQuery = [PFQuery queryWithClassName:@"Food"];
    foodQuery.limit = 5000;
    [foodQuery findObjectsInBackgroundWithBlock:^(NSArray * foods, NSError * error) {
            for (PFObject *foodRaw in foods) {
                MenuItem *food = [[MenuItem alloc] initWithName:[foodRaw valueForKey:@"name"]  andURL:nil];
                [foodArr addObject:food];
            }
        
        return foodArr;

    }];
}
 */
- (void) hideViews {
    
    
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