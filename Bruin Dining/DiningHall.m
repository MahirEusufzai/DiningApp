//
//  DiningHall.m
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "DiningHall.h"

@implementation DiningHall


- (id) initWithName:(NSString*)n //andURL:(NSString *)url

{
    self = [super init];
    if (self) {
        self.name = n;
        self.stationList = [[NSMutableDictionary alloc] init];
        _openingTime = _closingTime = _nextOpeningTime = nil;

    }
    return self;
}

- (void) addStation:(Station*)station {
    [self.stationList setValue:station forKey:station.name];
    
}

- (void) setHoursFromData:(HourMeal*)data {
    
    if (data.openingTime && data.closingTime){
    _openingTime = data.openingTime;
    _closingTime = data.closingTime;
    
    }

}

- (BOOL)isOpen {
    
    if (!_openingTime || !_closingTime)
        return false;
    
    NSComparisonResult compareOpen = [[NSDate date] compare : _openingTime];
    NSComparisonResult compareClose = [[NSDate date] compare : _closingTime];

    //check if current time in between open and close
    if ((compareOpen == NSOrderedDescending || compareOpen == NSOrderedSame) && (compareClose == NSOrderedAscending || compareOpen == NSOrderedSame))
        return true;
    
    return false;
}

- (NSInteger)getTimeUntilOpens {
    //if meal hasn't started, show opening time for current meal;
    
    if (self.closedForCurrentMeal)
        return -1; //return of -1 signifies no opening time

    
    NSInteger timeUntilCurrentMealOpens = [_openingTime timeIntervalSinceDate:[NSDate date]];
    if (timeUntilCurrentMealOpens >=0)
        return timeUntilCurrentMealOpens;
    else
        return -1;
    /*
    if (self.closedForNextMeal)
        return -1;
    
    return (NSInteger)[_nextOpeningTime timeIntervalSinceDate:[NSDate date]];
     */
}


- (NSInteger)getTimeUntilCloses {
    
    return (NSInteger)[_closingTime timeIntervalSinceDate:[NSDate date]];
}

- (BOOL)closedForCurrentMeal {
    return (_openingTime == nil);
}

- (BOOL)closedForNextMeal {
    return (_nextOpeningTime == nil);
}

+ (NSString *)convertName:(NSString *)name {
    
    if ([name isEqualToString:@"FEAST at Rieber"]) {
        return @"Feast";
    }
    else if ([name isEqualToString:@"Sproul"] || [name isEqualToString:@"Bruin Plate"]){
        return @"B Plate";
    }
    return name;
}
@end
