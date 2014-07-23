//
//  DataLoader.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 4/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MenuLoader.h"

static const NSString *BREAKFAST_COMPLETE = @"http://menu.ha.ucla.edu/foodpro/default.asp?meal=1&threshold=2";
static const NSString *LUNCH_COMPLETE = @"http://menu.ha.ucla.edu/foodpro/default.asp?meal=2&threshold=2";
static const NSString *DINNER_COMPLETE = @"http://menu.ha.ucla.edu/foodpro/default.asp?meal=3&threshold=2";
static const NSString *SUMMARY = @"http://menu.ha.ucla.edu/foodpro/default.asp";
static const NSString *HOURS = @"https://secure5.ha.ucla.edu/restauranthours/dining-hall-hours-by-day.cfm";
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
    //set hours
    TFHpple *urlData = [self getNodeDataForURL:HOURS];
   
    for (DiningHall *hall in [m.hallList allValues]) {
        NSArray *data = [self getHourDataForHall:hall.name Meal:meal data:urlData];
        [hall setHoursFromData:data];
    }
    NSArray *tableCells = [self getTableEntriesForMeal:meal Type:spec];
    
    NSArray *hallNames = [NSArray arrayWithObjects: @"Covel", @"Hedrick", @"B Plate", @"Feast", nil];
    
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
                    TFHppleElement *imageNode = [listElement firstChildWithTagName:@"img"];
                    
                    //Add link property to food
                    NSString *linkAddress = [aNode objectForKey:@"href"];
                    if (linkAddress)
                        food.link = [NSURL URLWithString:linkAddress];
                    //Detect vegan/vegetarian
                    if ([[imageNode objectForKey:@"alt"] isEqualToString:@"Vegan Menu Option"])
                        food.isVegan = YES;
                    if ([[imageNode objectForKey:@"alt"] isEqualToString:@"Vegetarian Menu Option"])
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
        url = BREAKFAST_COMPLETE;
    }
    //summary available for lunch and dinner
    else if (spec == specificitySummary)
        url = SUMMARY;
    
    else if ([meal isEqualToString:@"lunch"])
        url = LUNCH_COMPLETE;
    
    else
        url = DINNER_COMPLETE;
    
    TFHpple *parser = [self getNodeDataForURL:url];
    
    NSString *TDString = @"//td[starts-with(@class, 'menugridcell')]";

    if ((![meal isEqualToString:@"breakfast"]) && spec == specificitySummary) {
        
        NSString *queryString = @"//table[starts-with(@class, 'menugridtable')]";
        NSArray *mealCells = [parser searchWithXPathQuery:queryString];
        
        if ([meal isEqualToString:@"lunch"])
            return [mealCells[0] searchWithXPathQuery:TDString];
        else
            return [mealCells[1] searchWithXPathQuery:TDString];
        
    }
    return [parser searchWithXPathQuery:TDString];
    
}

#pragma mark -- hour data 

-(NSArray*) getHourDataForHall:(NSString*)hall Meal:(NSString*)meal data:(TFHppleElement*)pageData {
    
    NSArray *tables = [pageData searchWithXPathQuery:@"//table"];
    TFHppleElement *hoursTable;
    for (TFHppleElement *table in tables)
        if ([table childrenWithTagName:@"tr"].count>=4) //largest table
            hoursTable = table;
    if (!hoursTable)
        hoursTable = tables[8];
    
    NSArray *rows = [hoursTable childrenWithTagName:@"tr"];
    
    TFHppleElement *desiredRow;
    
    for (TFHppleElement *row in rows) {
        TFHppleElement* td = [row firstChildWithTagName:@"td"];
        TFHppleElement* strong = [td firstChildWithTagName:@"strong"];
        TFHppleElement* text = [strong firstChildWithTagName:@"text"];
    
        
        NSString *title = text.content;
       // NSLog(@"%@", title);
        
        if ([hall isEqualToString:@"Covel"] && [title isEqualToString:@"Covel"])
            desiredRow = row;
        
        else if ([hall isEqualToString:@"Feast"] && [title isEqualToString:@"FEAST at Rieber"])
            desiredRow = row;
        else if ([hall isEqualToString:@"Hedrick"] && [title isEqualToString:@"Hedrick"])
            desiredRow = row;
        
        else if ([hall isEqualToString:@"B Plate"] && [title isEqualToString:@"Sproul"])
            desiredRow = row;
    
    }
    return [self getHourDataForRow:desiredRow Meal:meal];
}

- (NSArray*) getHourDataForRow:(TFHppleElement*)row Meal:(NSString*)meal {
    
    NSArray *meals = [row childrenWithTagName:@"td"];
    NSArray *mealNames = [NSArray arrayWithObjects:@"breakfast", @"lunch", @"dinner", nil];
    int index = [mealNames indexOfObject:meal]+1;
    TFHppleElement *cell = meals[index];
    NSArray *strong = [cell childrenWithTagName:@"strong"];
    
    NSMutableString* raw = [NSMutableString stringWithString:@""];
    for (TFHppleElement *element in strong){
    TFHppleElement* text = [element firstChildWithTagName:@"text"];
        [raw appendString:text.content];
    }
    NSMutableArray *retArr = [NSMutableArray array];
    NSArray *begAndClose = [raw componentsSeparatedByString:@" -"];

    NSDate *first = [self dateFromString:begAndClose[0]];
    if (first)
    [retArr addObject:first];
    else
        [retArr addObject:[NSNull null]];
    
    if (begAndClose.count > 1)
        [retArr addObject: [self dateFromString:begAndClose[1]]];
    else
        [retArr addObject:[NSNull null]]; //nil if closed
    
    if (index +1 <= 3){
        
        TFHppleElement *nextCell = meals[index+1];
        NSArray *strong = [nextCell childrenWithTagName:@"strong"];
        TFHppleElement* text = [strong[0] firstChildWithTagName:@"text"];
        [retArr addObject:[self dateFromString:text.content]];
    }
    else
        [retArr addObject:[NSNull null]];

    return retArr;
}



- (NSDate*) dateFromString:(NSString*)time {
    
    if ([time isEqualToString:@"CLOSED"])
        return nil;
    
        NSArray *digits = [time componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        
        int hour = [digits[0] intValue];
        hour+= (([time rangeOfString:@"pm"].location == NSNotFound) ? 0:12) ; //add 12 for pm
        int minutes = [digits[1] intValue];
        //format nsdate
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit ) fromDate:[NSDate date]];
        [components setHour:hour];
        [components setMinute:minutes];
        return [calendar dateFromComponents:components];
    
}
    
- (TFHpple*) getNodeDataForURL:(NSString*)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *pageData = [NSData dataWithContentsOfURL:url];
    return [TFHpple hppleWithHTMLData:pageData];
}

@end
