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
      

    }
    return self;
}

- (void) addStation:(Station*)station {
    [self.stationList setValue:station forKey:station.name];
    
}


@end
