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
static const NSString *SUMMARY = @"http://menu.ha.ucla.edu/foodpro/default.asp?";
static const NSString *HOURS = @"https://secure5.ha.ucla.edu/restauranthours/dining-hall-hours-by-day.cfm";
static const int INDEX_NOT_FOUND = 1;
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
    NSDate *bTime = [h earliestOpeningForMeal:MealTypeBreakfast];

    NSDate *lTime = [h earliestOpeningForMeal:MealTypeLunch];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mma"];
    
    
    NSString *nowTime = [formatter stringFromDate:currentDate];
    NSString *mealTime = [formatter stringFromDate:lTime];

    if (bTime && lTime && [currentDate compare: lTime] == NSOrderedAscending)
        return MealTypeBreakfast;
    
    NSDate *dTime = [h earliestOpeningForMeal:MealTypeDinner];
    
    if (dTime && [currentDate compare:dTime] == NSOrderedAscending)
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
    NSArray *tableCells = [table searchWithXPathQuery:@"//td[starts-with(@class, 'menugridcell')]"];
    
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
    for (TFHppleElement *table in tableList) {
        NSArray *hallsInCurrentTable = [table searchWithXPathQuery:@"//td[starts-with(@class, 'menulocheader')]"];
        [self setFoodsInMeal:m ForData:table MealType:meal Specificity:spec];

    }

    return m;
}


- (NSArray*) gridTables:(MealType)mealType Type:(Specificity)spec {
    NSString *url;
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
    NSString *queryString = @"//table[starts-with(@class, 'menugridtable')]";
    NSArray *mealCells = [parser searchWithXPathQuery:queryString];
    if (!mealCells)
        return nil;
    int lunchIndex = INDEX_NOT_FOUND, dinnerIndex = INDEX_NOT_FOUND; // determine which cells correspond to l/d
    int i = 0;
    for (TFHppleElement *cell in mealCells) {
        TFHppleElement *mealHeader = [[[cell firstChildWithTagName:@"tbody"]
                                        firstChildWithTagName:@"tr"]firstChildWithClassName:@"menumealheader"];
        if (mealHeader && lunchIndex == INDEX_NOT_FOUND)
            lunchIndex = i;
        else if (mealHeader)
            dinnerIndex = i;
        i++;
    }
    
    
    if (spec == specificitySummary && mealType!=MealTypeBreakfast) {
        if (mealType == MealTypeLunch && lunchIndex != INDEX_NOT_FOUND) {
            NSLog(@"lunch index is %d, dinner index is %d", lunchIndex, dinnerIndex);
            int length = dinnerIndex != INDEX_NOT_FOUND ? dinnerIndex - lunchIndex : mealCells.count;
            return [mealCells subarrayWithRange:NSMakeRange(lunchIndex, length)];
        }
        else if (mealType == MealTypeDinner && dinnerIndex != INDEX_NOT_FOUND)
            return [mealCells subarrayWithRange:NSMakeRange(dinnerIndex, mealCells.count - dinnerIndex)];
        //return empty if index not found
        return nil;
    }
    //explicit or breakfast
    return [mealCells subarrayWithRange:NSMakeRange(0, mealCells.count)];


}



#pragma mark -- hour data


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
