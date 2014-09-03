//
//  HourHalls.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 7/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HourMeal.h"

@interface HourHalls : NSObject

@property (nonatomic, retain) NSMutableDictionary *mealList;

-(void)setOpening:(NSDate*)opening ForMeal:(MealType)meal;
-(void)setClosing:(NSDate*)closing ForMeal:(MealType)meal;
-(HourMeal*)HoursForMeal:(MealType)meal;
@end
