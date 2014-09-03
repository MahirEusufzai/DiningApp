//
//  HourMeal.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 7/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MealType.h"
@interface HourMeal : NSObject


@property (nonatomic, retain) NSDate *openingTime;
@property (nonatomic, retain) NSDate *closingTime;

-(NSArray*)getHours;
+ (NSString*)stringForMealType:(MealType)mealType;
@end
