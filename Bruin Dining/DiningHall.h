//
//  DiningHall.h
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Station.h"

@interface DiningHall : NSObject


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSMutableDictionary *stationList;
@property (nonatomic, retain) NSDate *openingTime;
@property (nonatomic, retain) NSDate *closingTime;
@property (nonatomic, retain) NSDate *nextOpeningTime;

- (id) initWithName:(NSString*)n;
- (void) addStation:(Station*)station;
- (void) setHoursFromData:(NSArray*)data;
- (BOOL) isOpen;
- (BOOL) closedForCurrentMeal;
- (BOOL) closedForNextMeal;
- (NSInteger) getTimeUntilOpens;
- (NSInteger) getTimeUntilCloses;

+ (NSString*)convertName:(NSString*)name;
@end
