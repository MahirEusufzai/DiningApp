//
//  DataLoader.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 4/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MenuLoader.h"

static const NSString *BREAKFAST_COMPLETE = @"http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F09%2F2014&meal=1&threshold=2";
static const NSString *LUNCH_COMPLETE = @"http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F09%2F2014&meal=2&threshold=2";
static const NSString *DINNER_COMPLETE = @"http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F09%2F2014&meal=3&threshold=2";
static const NSString *SUMMARY = @"http://menu.ha.ucla.edu/foodpro/default.asp?date=7%2F09%2F2014";

@implementation MenuLoader

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (Meal *)loadDiningDataForMeal:(NSString *)meal Specificity:(Specificity)spec {
    
    Meal *m = [[Meal alloc] initWithName:meal];
    NSArray *tableCells = [self getTableEntriesForMeal:meal Type:spec];
    
    NSArray *hallNames = [NSArray arrayWithObjects: @"Covel", @"De Neve", @"B Plate", @"Feast", nil];
    
    int count = 0;
    
    for (TFHppleElement *cell in tableCells) {
        
        TFHppleElement *listNode = [cell firstChildWithTagName:@"ul"]; //contains a cell's list
        
        if (listNode) {         //skips blank cells
            
            NSArray *listChildren = [listNode childrenWithTagName:@"li"];
            TFHppleElement *title = listChildren[0];
            Station *station = [[Station alloc] initWithName:title.text];
          
            //iterate through each food
            for (TFHppleElement *listElement in listChildren) {
                
                if (listElement != listChildren[0]){  //first element is title
                
                    TFHppleElement *aNode = [listElement firstChildWithTagName:@"a"];
                    MenuItem *food = [[MenuItem alloc] initWithName:aNode.text andURL:nil];
                    TFHppleElement *anotherNode = [listElement firstChildWithTagName:@"img"];
                    
                    //Add link property to food
                    food.link = [aNode objectForKey:@"href"];
                    //Detect vegan/vegetarian
                    if ([[anotherNode objectForKey:@"alt"] isEqualToString:@"Vegan Menu Option"])
                        food.isVegan = YES;
                    if ([[anotherNode objectForKey:@"alt"] isEqualToString:@"Vegetarian Menu Option"])
                        food.isVegetarian = YES;

                    [station addFood:food];
                }
            }
            DiningHall *curr = [m.hallList objectForKey:[hallNames objectAtIndex:count%4]];
            [curr addStation:station];
        }
        count++;
        
    }
    
    return m;
}

- (NSArray*)getTableEntriesForMeal:(NSString *)meal Type:(Specificity)spec {
    
    NSString *url;
    
    //no summary menu available for breakfast, so always so full menu
    if ([meal isEqualToString:@"breakfast"]){
        url = [NSURL URLWithString:BREAKFAST_COMPLETE];
    }
    //summary available for lunch and dinner
    else if (spec == specificitySummary)
        url = [NSURL URLWithString:SUMMARY];
    
    else if ([meal isEqualToString:@"lunch"])
        url = [NSURL URLWithString:LUNCH_COMPLETE];
    
    else
        url = [NSURL URLWithString:DINNER_COMPLETE];
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *pageData = [NSData dataWithContentsOfURL:url];
    TFHpple *parser = [TFHpple hppleWithHTMLData:pageData];
    
    if ((![meal isEqualToString:@"breakfast"]) && spec == specificitySummary) {
        
        NSString *queryString = @"//table[starts-with(@class, 'menugridtable')]";
        NSArray *mealCells = [parser searchWithXPathQuery:queryString];
        
        if ([meal isEqualToString:@"lunch"])
            return [mealCells[0] searchWithXPathQuery:@"//td[starts-with(@class, 'menugridcell')]"];
        else
            return [mealCells[1] searchWithXPathQuery:@"//td[starts-with(@class, 'menugridcell')]"];
        
    }
    return [parser searchWithXPathQuery:@"//td[starts-with(@class, 'menugridcell')]"];
    
}


@end
