//
//  MenuItem.m
//  UCLA_Dining
//
//  Created by Mahir Eusufzai on 3/26/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (id) initWithName:(NSString*)n andURL:(NSString*)url

{
    self = [super init];
    if (self) {
        self.name = n;
        self.isVegetarian = FALSE;
        self.link = nil;
    }
    return self;
}
@end
