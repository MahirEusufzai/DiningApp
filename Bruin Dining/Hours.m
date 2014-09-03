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

- (void)addHall:(NSString *)hallName {
    
    [self.hallList setValue:[[HourHalls alloc]init] forKey:hallName];
     
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
        return @"Sproul";
    else if ([oldName isEqualToString:@"Feast"])
        return @"FEAST at Rieber";
    else
        return oldName;
}

- (NSDate *)earliestOpeningForMeal:(MealType)meal {
   
    NSDate *earliest;
    
    for (HourHalls *hall in [_hallList allValues]) {
        NSDate *cur = [hall HoursForMeal:meal].openingTime;
        if (cur && (!earliest || [earliest compare : cur] == NSOrderedAscending)){
            earliest = cur;
        }
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
