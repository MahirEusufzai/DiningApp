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
        [[HourMeal alloc]init], @"Breakfast",
        [[HourMeal alloc]init], @"Lunch",
        [[HourMeal alloc]init], @"Dinner",
        nil];
    }
    return self;
}
- (void)setOpening:(NSDate *)opening ForMeal:(MealType)meal {
    
    HourMeal *m = [self.mealList objectForKey:[Meal stringForMealType:meal]];
    m.openingTime = opening;

}

- (void)setClosing:(NSDate *)closing ForMeal:(MealType)meal {
  
    HourMeal *m = [self.mealList objectForKey:[Meal stringForMealType:meal]];
    m.closingTime = closing;

}

- (NSArray *)HoursForMeal:(MealType)meal {
    HourMeal *m = [self.mealList objectForKey:[Meal stringForMealType:meal]];
    return [m getHours];
}
@end
