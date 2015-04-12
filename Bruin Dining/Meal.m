
//
//  Meal.m
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "Meal.h"

@implementation Meal


- (id) initWithType:(MealType)meal Date:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.type = meal;
        self.name = [MealTypes stringForMealType:meal];
        self.hallList = [[NSMutableDictionary alloc] init];
        self.date = date;
        
        //TO DO: Don't hard code dining hall names
        
        NSArray *names = [NSArray arrayWithObjects: @"Covel", @"De Neve", @"B Plate", @"Feast", nil];
        
        for (NSString *name in names)
            [self addHall:[[DiningHall alloc] initWithName:name]];
        
    }
    return self;
}


- (void)addHall:(DiningHall *)hall{
    [self.hallList setValue:hall forKey:hall.name];
}


- (Station*)getStation:(int)stationIndex ForHall:(NSString *)hallName {
    
    DiningHall *d = [self.hallList valueForKey:hallName];
    NSArray *stations = [d.stationList allValues];
    return [stations objectAtIndex:stationIndex];
    
    
}



- (void)addStation:(Station *)station ToHall:(NSString *)hall {
    
    DiningHall *curr = [self.hallList objectForKey:hall];
    [curr addStation:station];
    
}



+(MealType)mealBeforeMeal:(MealType)currentMeal {
    if (currentMeal == MealTypeUnknown){
        currentMeal = [Meal predictCurrentMeal];
    }
    
    if (currentMeal == MealTypeBreakfast)
        return MealTypeDinner;
    else
        return currentMeal-1;
}

+(MealType)mealAfterMeal:(MealType)currentMeal {
    
    if (currentMeal == MealTypeUnknown){
        currentMeal = [Meal predictCurrentMeal];
    }
    
    if (currentMeal == MealTypeDinner)
        return MealTypeBreakfast;
    else
        return currentMeal+1;
}

+ (NSDate *)nextMealDateFromDate:(NSDate*)currentDate type:(MealType)type{
    
    if (type == MealTypeDinner){
        NSDate *date = currentDate
        ; // your date from the server will go here.
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = 1;
        NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];

        NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newDate];
        NSInteger day = [components1 day];
        NSInteger month = [components1 month];
        NSInteger year = [components1 year];
        
        return newDate;
    }
    else{
        return currentDate;
    }
}


+ (NSDate *)prevMealDateFromDate:(NSDate*)currentDate type:(MealType)type {
    
    if (type == MealTypeBreakfast){
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = -1;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
        return nextDate;
    }
    else{
        return currentDate;
    }
    
}



+ (MealType)predictCurrentMeal {
    //use if hours cannot load in time
    BOOL isWeekend = [Meal currentDayIsWeekend];
    NSDate *breakfastEnd = !isWeekend ? [Meal dateFromString:@"10:00am"] : nil;
    NSDate *lunchEnd = isWeekend ? [Meal dateFromString:@"2:30pm"] : [Meal dateFromString:@"3:00pm"];
    
    NSDate *currentTime = [NSDate date];
    
    if (breakfastEnd && [currentTime compare: breakfastEnd] == NSOrderedAscending){
        return MealTypeBreakfast;
    }
    else if ([currentTime compare: lunchEnd] == NSOrderedAscending){
        return MealTypeLunch;
    }
    else{
        return MealTypeDinner;
    }
}


+(BOOL) currentDayIsWeekend {
    
    NSDate *aDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:aDate];
    NSUInteger weekdayOfDate = [components weekday];
    
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length){
        return true;
    }
    else
        return false;
    
}

+ (NSDate*) dateFromString:(NSString*)time {
    
    
    if ([time isEqualToString:@"CLOSED"])
        return nil;
    
    NSArray *digits = [time componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    
    int hour = [digits[0] intValue];
    hour+= (([time rangeOfString:@"pm"].location == NSNotFound) ? 0:12) ; //add 12 for pm
    int minutes = [digits[1] intValue];
    //format nsdate
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit ) fromDate:[NSDate date]];
    [components setHour:hour];
    [components setMinute:minutes];
    return [calendar dateFromComponents:components];
    
}


@end

