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
        self.link = [NSURL URLWithString:url];
        self.isFavorite = [self isInFavoriteList:n];
    }
    return self;
}

- (id)initWithName:(NSString *)n {
    self = [super init];
    if (self) {
        self.name = n;
        self.isVegetarian = FALSE;
        self.link = nil;
        self.isFavorite = [self isInFavoriteList:n];
    }
    return self;
}

- (BOOL) isInFavoriteList:(NSString*)foodName {
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    NSArray *foodList = (NSArray*)[installation objectForKey:@"favorites"];
    return ([foodList containsObject:foodName]);
}

- (void) toggleFavorites {
    
    _isFavorite = !_isFavorite;
}

- (void)toggleFavoritesIfNeeded {
    //check if favorite changed
    if (_isFavorite !=[self isInFavoriteList:_name])
        [self toggleFavorites];
}
- (void)saveToDatabase {
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation addUniqueObject:_name forKey:@"favorites"];
    [installation saveInBackground];
    
}

- (void)removeFromDatabase {
    
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation removeObject:_name forKey:@"favorites"];
    [installation saveInBackground];
}
@end
