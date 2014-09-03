//
//  Meal.h
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiningHall.h"
#import "MealType.h"


@interface Meal : NSObject {
    
}

@property (nonatomic, retain) NSMutableDictionary *hallList;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) MealType type;



- (id) initWithType:(MealType)meal;
- (void) addHall:(DiningHall*)hall;
- (void) addStation:(Station*)station ToHall:(NSString*)hall;
- (Station*)getStation:(int)stationIndex ForHall:(NSString*)hallName;
@end

