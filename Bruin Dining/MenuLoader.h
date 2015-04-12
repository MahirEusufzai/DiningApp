//
//  DataLoader.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 4/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meal.h"
#import "TFHpple.h"
#import "Hours.h"

typedef NS_ENUM(NSInteger, Specificity) {
    specificitySummary,
    specificityExplicit
};

@interface MenuLoader : NSObject {
    
    
    DiningHall *covel, *deNeve, *bPlate, *feast;
    NSDictionary *hallList;

}

//specificity = summary vs full menu
- (Meal*) mealForType:(MealType)meal Specificity:(Specificity)spec Date:(NSDate*)date;
- (void) loadHoursForDate:(NSDate*)date;
- (Hours*)approximateHours;
- (MealType)determineCurrentMealForHours:(Hours*)h;
+(MealType)MealAfterMeal:(MealType)currentMeal;
+(MealType)MealBeforeMeal:(MealType)currentMeal;
+ (MealType)predictCurrentMeal;

@end
