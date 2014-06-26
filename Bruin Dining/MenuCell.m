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
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)registerFavorite:(id)sender {
    
   /*
    */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *parseID = [defaults stringForKey:@"parseID"];
   // NSLog(@"id is %@", parseID);
    if (parseID) {
        NSLog(@"seasoned veteran");
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

        
        
       // [user save];//InBackground];
      
    }
  

}
@end
