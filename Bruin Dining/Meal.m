//
//  Meal.m
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "Meal.h"

@implementation Meal


- (id) initWithName:(NSString*)n
{
    self = [super init];
    if (self) {
        
        self.name = n;
        self.hallList = [[NSMutableDictionary alloc] init];
      
        //TO DO: Don't hard code dining hall names
        [self addHall:[[DiningHall alloc] initWithName:@"Covel"]];
        [self addHall:[[DiningHall alloc] initWithName:@"De Neve"]];
        [self addHall:[[DiningHall alloc] initWithName:@"B Plate"]];
        [self addHall:[[DiningHall alloc] initWithName:@"Feast"]];
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
@end
