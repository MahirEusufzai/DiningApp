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

- (MealType)determineCurrentMealForHours:(Hours*)h {
    
    NSDate *currentDate = [NSDate date];
    
    NSDate *d = [h earliestOpeningForMeal:MealTypeLunch];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mma"];
    
    
    NSString *nowTime = [formatter stringFromDate:currentDate];
    NSString *mealTime = [formatter stringFromDate:d];
    NSLog(@"now is %@ and d is %@", nowTime, mealTime);

    if (d && [currentDate compare: d] == NSOrderedAscending)
        return MealTypeBreakfast;
    
    NSDate *d2 = [h earliestOpeningForMeal:MealTypeDinner];
    
    if (d2 && [currentDate compare:d2] == NSOrderedAscending)
        return MealTypeLunch;
    
    return MealTypeDinner;
}

- (Hours*) getHours {
    // check if hours exist for current date, otherwise parse from website
    return [self parseHoursFromServer];
}

- (Hours*)parseHoursFromServer {
    Hours *h = [[Hours alloc] init];
    //set hours
    TFHpple *urlData = [self getNodeDataForURL:HOURS];
    
    NSArray *tables = [urlData searchWithXPathQuery:@"//table"];
    TFHppleElement *hoursTable;
    for (TFHppleElement *table in tables){
        if ([table childrenWithTagName:@"tr"].count>=4) {//largest table
            hoursTable = table;
        }
    }
    if (!hoursTable)
        hoursTable = tables[8];
    
    NSArray *rows = [hoursTable childrenWithTagName:@"tr"];
    int count = 0;
    for (TFHppleElement *row in rows) {
        
        if (count>=2) {
            
            TFHppleElement* td = [row firstChildWithTagName:@"td"];
            TFHppleElement* strong = [td firstChildWithTagName:@"strong"];
            NSString *text = [strong firstChildWithTagName:@"text"].content;
            
            if ([h addHall:text]){
                [self setRow:row Named:text ForHours:h];
            }
        }
        count++;
        
    }
    return h;
    
}

- (void)setRow:(TFHppleElement*)row Named:(NSString*)hallName ForHours:(Hours*)h {
    NSArray *meals = [NSArray arrayWithObjects:
                      [NSNumber numberWithInt:MealTypeBreakfast],
                       [NSNumber numberWithInt:MealTypeLunch],
                       [NSNumber numberWithInt:MealTypeDinner], nil];
   
    NSArray *td = [row childrenWithTagName:@"td"];
    for (int i = 1; i <=3; i++) {
        TFHppleElement *currentMeal = td[i];
        NSArray *strong = [currentMeal childrenWithTagName:@"strong"];
        
        NSString *opening = [strong[0] firstChildWithTagName:@"text"].content;
        NSDate *openingAsDate = [self dateFromString:opening];
        [h addOpeningTime:openingAsDate ToMeal:[meals[i-1] intValue] Hall:hallName];
        NSDate *closingAsDate;
        if (openingAsDate){
        NSString *closing = [strong[1] firstChildWithTagName:@"text"].content;
         closingAsDate = [self dateFromString:closing];
        }
        else
        closingAsDate = nil;
        
        [h addClosingTime:closingAsDate ToMeal:[meals[i-1] intValue] Hall:hallName];
    }

}


- (void)setFoodsInMeal:(Meal *)m ForData:(TFHppleElement*)table MealType:(MealType)mealType Specificity:(Specificity)spec {
    NSArray *hallNamesRaw = [table searchWithXPathQuery:@"//td[starts-with(@class, 'menulocheader')]"];
    NSMutableArray *hallNames = [NSMutableArray array];
    for (TFHppleElement *hallNameRaw in hallNamesRaw){
        TFHppleElement* a = [hallNameRaw firstChildWithTagName:@"a"];
        TFHppleElement* text = [a firstChildWithTagName:@"text"];
        [hallNames addObject:text.content];
    }
    
    //NSArray *hallNames = [NSArray arrayWithObjects: @"Covel", @"Hedrick", @"B Plate", @"Feast", nil];
    
    int count = 0;
    NSArray *tableCells = [self getTableEntriesFromTable:table ForMeal:mealType Type:spec];
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
            NSString *hallName = [hallNames objectAtIndex:count%(hallNames.count)];
            [m addStation:station ToHall:[DiningHall convertName:hallName]];
        }
        count++;
        
    }
}

- (Meal *)mealForType:(MealType)meal Specificity:(Specificity)spec {
    
    //set hours
    Hours *h = [self getHours];
    
    if (meal == MealTypeUnknown)
        meal = [self determineCurrentMealForHours:h];
    
    Meal *m = [[Meal alloc] initWithType:meal];
    for (DiningHall *hall in [m.hallList allValues]) {
        HourMeal *hm = [h getHoursForMeal:meal Hall:hall.name];
        [hall setHoursFromData:hm];
    }
    NSArray *tableList = [self gridTables:meal Type:spec];
    //NSMutableArray *hallNamesRaw =[NSMutableArray array];
    for (TFHppleElement *table in tableList) {
        NSArray *hallsInCurrentTable = [table searchWithXPathQuery:@"//td[starts-with(@class, 'menulocheader')]"];
        //[hallNamesRaw addObjectsFromArray:hallsInCurrentTable];
//        NSArray *tableCells = [self getTableEntriesFromTable:table ForMeal:meal Type:spec];
        [self setFoodsInMeal:m ForData:table MealType:meal Specificity:spec];

    }
    //**********
   /* TFHppleElement *table = [self gridTable:meal Type:spec];
    NSArray *halls = [table searchWithXPathQuery:@"//td[starts-with(@class, 'menulocheader')]"];
    NSMutableArray *hallNames = [NSMutableArray array];
    for (TFHppleElement *hall in halls){
        TFHppleElement* a = [hall firstChildWithTagName:@"a"];
        TFHppleElement* text = [a firstChildWithTagName:@"text"];
        [hallNames addObject:text.content];
    }
    */
    
    
    
    return m;
}

- (TFHppleElement*) gridTable:(MealType)mealType Type:(Specificity)spec {
    
    NSString *url;
    NSString* meal = [MealTypes stringForMealType:mealType];
    //no summary menu available for breakfast, so always so full menu
    switch (mealType) {
        case MealTypeBreakfast:
            url = BREAKFAST_COMPLETE; //there is no breakfast summary
            break;
        case MealTypeLunch:
            if (spec == specificitySummary) {
                url = SUMMARY;
            } else{
                url = LUNCH_COMPLETE;
            }
            break;
        case MealTypeDinner:
            if (spec == specificitySummary) {
                url = SUMMARY;
            } else {
                url = DINNER_COMPLETE;
            }
        default:
            break;
    }
    
    TFHpple *parser = [self getNodeDataForURL:url];
    //array of gridtable
    /*
     summmary -- first 2 lunch, next 2 dinner
     breakfast -- first 1
     lunch -- first 2
     dinner -- first 2
     */
    NSString *queryString = @"//table[starts-with(@class, 'menugridtable')]";
    NSArray *mealCells = [parser searchWithXPathQuery:queryString];
    
    if (spec == specificitySummary) {
        if (mealType == MealTypeLunch)
            return mealCells[0];
        else if (mealType == MealTypeDinner)
            return mealCells[1];
    }
    
    return mealCells[0];

}

- (NSArray*) gridTables:(MealType)mealType Type:(Specificity)spec {
    
    NSString *url;
    NSString* meal = [MealTypes stringForMealType:mealType];
    //no summary menu available for breakfast, so always so full menu
    switch (mealType) {
        case MealTypeBreakfast:
            url = BREAKFAST_COMPLETE; //there is no breakfast summary
            break;
        case MealTypeLunch:
            if (spec == specificitySummary) {
                url = SUMMARY;
            } else{
                url = LUNCH_COMPLETE;
            }
            break;
        case MealTypeDinner:
            if (spec == specificitySummary) {
                url = SUMMARY;
            } else {
                url = DINNER_COMPLETE;
            }
        default:
            break;
    }
    
    TFHpple *parser = [self getNodeDataForURL:url];
    //array of gridtable
    /*
     summmary -- first 2 lunch, next 2 dinner
     breakfast -- first 1
     lunch -- first 2
     dinner -- first 2
     */
    NSString *queryString = @"//table[starts-with(@class, 'menugridtable')]";
    NSArray *mealCells = [parser searchWithXPathQuery:queryString];
    
    if (mealType == MealTypeBreakfast) {
        return [NSArray arrayWithObject:mealCells[0]];
    }
    if (spec == specificitySummary) {
        if (mealType == MealTypeLunch)
            return [mealCells subarrayWithRange:NSMakeRange(0, 2)];
        else if (mealType == MealTypeDinner)
            return [mealCells subarrayWithRange:NSMakeRange(2, 2)];
    }
    //full length, lunch or dinner
    return [mealCells subarrayWithRange:NSMakeRange(0, 2)];
}


- (NSArray*)getTableEntriesFromTable:(TFHppleElement *) table ForMeal:(MealType)mealType Type:(Specificity)spec {
    //NSArray *tables = [self gridTables:mealType Type:spec];
    
    //TFHppleElement *table = [self gridTable:mealType Type:spec];
    NSString *TDString = @"//td[starts-with(@class, 'menugridcell')]";
    //NSMutableArray *tableCells = [NSMutableArray array];
    //for (TFHppleElement *table in tables) {
     //   [tableCells addObjectsFromArray:[table searchWithXPathQuery:TDString]];
    //}
    return [table searchWithXPathQuery:TDString];
    //return tableCells;
}

#pragma mark -- hour data
/*
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
    
        if ([hall isEqualToString:@"Covel"] && [title isEqualToString:@"Covel"])
            desiredRow = row;
        
        else if ([hall isEqualToString:@"Feast"] && [title isEqualToString:@"FEAST at Rieber"])
            desiredRow = row;
        else if ([hall isEqualToString:@"De Neve"] && [title isEqualToString:@"De Neve"])
            desiredRow = row;
        else if ([hall isEqualToString:@"B Plate"] && [title isEqualToString:@"Bruin Plate"]){
            desiredRow = row;
        }
        
    }
    return [self getHourDataForRow:desiredRow Meal:meal];
}
 */

- (NSArray*) getHourDataForRow:(TFHppleElement*)row Meal:(NSString*)meal {
    
    NSArray *meals = [row childrenWithTagName:@"td"];
    NSArray *mealNames = [NSArray arrayWithObjects:@"breakfast", @"lunch", @"dinner", nil];
    int index = [mealNames indexOfObject:meal]+1;
    TFHppleElement *cell = meals[index];
    NSArray *strong = [cell childrenWithTagName:@"strong"];
    
    NSMutableArray *retArr = [NSMutableArray array];
    
    NSString *opening = [strong[0] firstChildWithTagName:@"text"].content;
    NSDate *openingAsDate = [self dateFromString:opening];
    if (openingAsDate){
        [retArr addObject:openingAsDate];
        NSString *closing = [strong[1] firstChildWithTagName:@"text"].content;
        [retArr addObject:[self dateFromString:closing]];
    }
    else{
        [retArr addObject:[NSNull null]];
        [retArr addObject:[NSNull null]];
    }
    
    if (index +1 <= 3){ //nextOpeningTime is always nil for dinner
        
        TFHppleElement *nextCell = meals[index+1];
        NSArray *strong1 = [nextCell childrenWithTagName:@"strong"];
        NSString* nextOpening = [strong1[0] firstChildWithTagName:@"text"].content;
        [retArr addObject:[self dateFromString:nextOpening]];
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



+(MealType)MealAfterMeal:(MealType)currentMeal {
    if (currentMeal == MealTypeDinner)
        return -1;
    else
        return currentMeal+1;
}

+(MealType)MealBeforeMeal:(MealType)currentMeal {
    if (currentMeal == MealTypeBreakfast)
        return -1;
    else
        return currentMeal-1;
}



@end
