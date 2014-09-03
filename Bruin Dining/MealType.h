//
//  MealType.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 9/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MealType : NSUInteger {
    MealTypeBreakfast,
    MealTypeLunch,
    MealTypeDinner,
    MealTypeUnknown
} MealType;

@interface MealTypes : NSObject

+ (NSString *)stringForMealType:(MealType)mealType;
@end
