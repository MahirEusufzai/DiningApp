//
//  SearchViewController.h
//  Bruin Dining
//
//  Created by William Gu on 8/6/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray* allFoodData;
@property (nonatomic, strong) NSArray* searchResults;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;


@end
