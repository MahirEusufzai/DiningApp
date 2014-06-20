//
//  Station.m
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "Station.h"

@implementation Station


- (id) initWithName:(NSString*)n

{
    self = [super init];
    if (self) {
        self.name = n;
        self.foodList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addFood:(MenuItem *)food {
    [self.foodList addObject:food];
    
}

@end
