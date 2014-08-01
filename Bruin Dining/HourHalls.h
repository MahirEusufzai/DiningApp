//
//  HourHalls.h
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 7/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HourMeal.h"

@interface HourHalls : NSObject

@property (nonatomic, retain) NSMutableDictionary *mealList;

-(void)setOpening:(NSDate*)opening ForMeal:(NSString*)meal;
-(void)setClosing:(NSDate*)closing ForMeal:(NSString*)meal;
-(NSArray*)HoursForMeal:(NSString*)meal;
@end
