//
//  Station.m
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "Station.h"

@implementation Station


- (id) initWithName:(NSString*)n

{
    self = [super init];
    if (self) {
        self.name = n;
        self.foodList = [[NSMutableArray alloc] init];
        self.vegetarianFoodList = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)addFood:(MenuItem *)food {
    [self.foodList addObject:food];
    
    if (food.isVegetarian || food.isVegan)
        [self.vegetarianFoodList addObject:food];
    
}

- (NSArray *)foodListForVegPref:(VegPreference)vegPref {
    
    switch (vegPref) {
        case VegPrefAll:
            return _foodList;
        case VegPrefVegetarian:
            return _vegetarianFoodList;
        case VegPrefVegan:
            return _vegetarianFoodList;
    }
}

@end
