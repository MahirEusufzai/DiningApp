//
//  Hours.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 7/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "Hours.h"

@implementation Hours

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hallList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)addHall:(NSString *)hallName {
    NSLog(@"name is %@", hallName);
    
    if ([self isValidHallName:hallName]){
        [self.hallList setValue:[[HourHalls alloc]init] forKey:hallName];
        NSLog(@"is valid");
        return true;
    }
    return false;
}

- (BOOL)isValidHallName:(NSString*)name {
    
    return  ([name isEqualToString:@"Covel"] || [name isEqualToString:@"De Neve"] || [name isEqualToString:@"Bruin Plate"] || [name isEqualToString:@"FEAST at Rieber"]);
}
- (void)addOpeningTime:(NSDate *)opening ToMeal:(MealType)meal Hall:(NSString *)hall {
    
    HourHalls* hall1 = [self.hallList objectForKey:hall];
    [hall1 setOpening:opening ForMeal:meal];
    
}

- (void)addClosingTime:(NSDate *)closing ToMeal:(MealType)meal Hall:(NSString *)hall {
    
    HourHalls* hall1 = [self.hallList objectForKey:hall];
    [hall1 setClosing:closing ForMeal:meal];
    
}

-(HourMeal*)getHoursForMeal:(MealType)meal Hall:(NSString *)hall {
    HourHalls* hall1 = [self.hallList objectForKey:[self realHallName:hall]];
    return [hall1 HoursForMeal:meal];
}

- (NSString*) realHallName:(NSString*)oldName {
    
    if ([oldName isEqualToString:@"B Plate"])
        return @"Bruin Plate";
    else if ([oldName isEqualToString:@"Feast"])
        return @"FEAST at Rieber";
    else
        return oldName;
}

- (NSDate *)earliestOpeningForMeal:(MealType)meal {
   
    NSDate *earliest;
    int count = 0;
    for (HourHalls *hall in [_hallList allValues]) {
        NSLog(@"%d", _hallList.allValues.count);
        NSDate *cur = [hall HoursForMeal:meal].openingTime;
       /*
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mma"];
        NSString *mealTime = [formatter stringFromDate:cur];
        NSLog(@"%@ d is %@", hall mealTime);
        */
        if (cur && (!earliest || [earliest compare : cur] == NSOrderedAscending)){
            earliest = cur;
        }
        count++;
    }
    return earliest;
}

- (NSDate *)latestClosingForMeal:(MealType)meal {
    
    NSDate *latest;
    
    for (HourHalls *hall in [_hallList allValues]) {
        NSDate *cur = [hall HoursForMeal:meal].closingTime;
        if (cur && (!latest || [cur compare : latest] == NSOrderedAscending)){
            latest = cur;
        }
    }
    return latest;
}
@end
