//
//  EditFavoritesController.h
//  Bruin Bites
//
//  Created by Mahir Eusufzai on 12/24/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"
@interface EditFavoritesController : UITableViewController

@property (nonatomic, retain) NSMutableArray *foodList;
@property (nonatomic, retain) IBOutlet UITableView *table;
@end
