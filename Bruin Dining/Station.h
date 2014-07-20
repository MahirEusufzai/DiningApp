//
//  Station.h
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface Station : NSObject
    


@property (nonatomic, retain) NSMutableArray *foodList;
@property (nonatomic, retain) NSMutableArray *vegetarianFoodList;
@property (nonatomic, retain) NSString *name;

- (id) initWithName:(NSString*)n;
- (void) addFood:(MenuItem*)food;
@end
