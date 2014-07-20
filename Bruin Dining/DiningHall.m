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

- (void) setHoursFromData:(NSArray*)data {
    
    if (data[0] != [NSNull null] && data[1] != [NSNull null]){
    _openingTime = data[0];
    _closingTime = data[1];
    
    }
    
    if (data[2] != [NSNull null])
    _nextOpeningTime = data[2];
    
}

- (BOOL)isOpen {
    
    if (!_openingTime || !_closingTime)
        return false;
    
    NSComparisonResult compareOpen = [[NSDate date] compare : _openingTime];
    NSComparisonResult compareClose = [[NSDate date] compare : _closingTime];

    if ((compareOpen == NSOrderedDescending || compareOpen == NSOrderedSame) && (compareClose == NSOrderedAscending || compareOpen == NSOrderedSame))
        return true;
    
    return false;
}

@end
