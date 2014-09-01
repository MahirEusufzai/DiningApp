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

typedef NS_ENUM(NSInteger, Specificity) {
    specificitySummary,
    specificityExplicit
};

@interface MenuLoader : NSObject {
    
    
    DiningHall *covel, *deNeve, *bPlate, *feast;
    NSDictionary *hallList;

}

//specificity = summary vs full menu
- (Meal*) loadDiningDataForMeal:(MealType)meal Specificity:(Specificity)spec;
- (void) loadHours;
- (MealType)determineCurrentMeal;
+(MealType)MealAfterMeal:(MealType)currentMeal;
+(MealType)MealBeforeMeal:(MealType)currentMeal;

@end
