//
//  MealType.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 9/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MealType.h"

@implementation MealTypes


+ (NSString *)stringForMealType:(MealType)mealType {
    NSArray *m = [NSArray arrayWithObjects:@"Breakfast", @"Lunch", @"Dinner", @"Unknown", nil];
    return m[mealType];
}

@end
