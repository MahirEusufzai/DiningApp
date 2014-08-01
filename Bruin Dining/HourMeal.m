//
//  HourMeal.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 7/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "HourMeal.h"

@implementation HourMeal

- (NSArray *)getHours {
    
    NSMutableArray *arr = [NSMutableArray array];
    if (_openingTime == nil)
        [arr addObject:[NSNull null]];
    else
        [arr addObject:_openingTime];
    
    if (_closingTime == nil)
        [arr addObject:[NSNull null]];
    else
        [arr addObject:_closingTime];
    
    return arr;
        
}
@end
