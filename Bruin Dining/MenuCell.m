//
//  MenuCell.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 6/22/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.foodLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:14];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)registerFavorite:(id)sender {
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation addUniqueObject:self.foodLabel.text forKey:@"favorites"];
    [installation saveInBackground];
    
    //test
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"favorites" equalTo:@"Fried Eggs"];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:@"Covel is serving fried eggs"];
    [push sendPushInBackground];
    
    /*
     
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *parseID = [defaults stringForKey:@"parseID"];

    if (parseID) {
        NSLog(@"returning user");
        //user has saved favorites before

        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query getObjectInBackgroundWithId:parseID block:^(PFObject *user, NSError *error) {
            
            [user addUniqueObject:self.foodLabel.text forKey:@"favorites"];
            [user saveInBackground];
            
        }];
        
    }
    
    else {
        NSLog(@"first time");
        //first time saving favorites
        PFObject *user = [PFObject objectWithClassName:@"User"];
        [user addUniqueObject:self.foodLabel.text forKey:@"favorites"];
        
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 NSLog(@"object id is %@", [user objectId]);
                 [defaults setObject:[user objectId] forKey:@"parseID"];
                 [defaults synchronize];
                 
             }];

    }
  */

    [self.favButton setImage:[UIImage imageNamed:@"star_full.png"] forState:UIControlStateNormal];
}
@end
