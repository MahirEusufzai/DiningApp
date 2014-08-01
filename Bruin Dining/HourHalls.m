//
//  HourHalls.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 7/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "HourHalls.h"

@implementation HourHalls

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mealList = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
        [[HourMeal alloc]init], @"breakfast",
        [[HourMeal alloc]init], @"lunch",
        [[HourMeal alloc]init], @"dinner",
        nil];
    }
    return self;
}
- (void)setOpening:(NSDate *)opening ForMeal:(NSString *)meal {
    
    HourMeal *m = [self.mealList objectForKey:meal];
    m.openingTime = opening;
}

- (void)setClosing:(NSDate *)closing ForMeal:(NSString *)meal {
  
    HourMeal *m = [self.mealList objectForKey:meal];
    m.closingTime = closing;
}

- (NSArray *)HoursForMeal:(NSString *)meal {
    
    HourMeal *m = [self.mealList objectForKey:meal];
    
    return [m getHours];
}
@end
