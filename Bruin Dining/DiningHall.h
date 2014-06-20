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


- (id) initWithName:(NSString*)n;
- (void) addStation:(Station*)station;

@end
