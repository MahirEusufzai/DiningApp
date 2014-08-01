//
//  DataLoader.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 4/2/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "MenuLoader.h"
#import "Hours.h"
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

- (NSString*)determineMealFromTime:(NSDate*)time data:(TFHpple*)data {
    
 //   [self setHours];
    
    NSDate *lunch = [self dateFromString:@"11:00am"];
    NSDate *dinner = [self dateFromString:@"5:00pm"];
    
    NSComparisonResult lunchComparison = [[NSDate date] compare : lunch];
    NSComparisonResult dinnerComparison = [[NSDate date] compare : dinner];
    
    if (lunchComparison == NSOrderedAscending)
        return @"breakfast";
    else if (dinnerComparison == NSOrderedAscending)
        return @"lunch";
    else
        return @"dinner";
    
    /*
     
     
     if      < lunch, show breakfast
     eles if < dinner, show lunch
     eles              show dinner
     */
    
    
}

- (Hours*) getHours {
    // check if hours exist for current date, otherwise parse from website
   
    return [self parseHoursFromServer];
    /*NSDictionary *d = [self stateFromDocumentNamed:@"Hours"];
    if (d == nil) {
        NSLog(@"nil");
        [self saveStateToDocumentNamed:@"Hours"];
        return [self parseHoursFromServer];
    } else {
        NSLog(@"exists");
        return [d valueForKey:@"Hours"];
    }
     */
   
}

- (Hours*)parseHoursFromServer {
    
    Hours *h = [[Hours alloc] init];
    //set hours
    TFHpple *urlData = [self getNodeDataForURL:HOURS];
    
    NSArray *tables = [urlData searchWithXPathQuery:@"//table"];
    TFHppleElement *hoursTable;
    for (TFHppleElement *table in tables)
        if ([table childrenWithTagName:@"tr"].count>=4) //largest table
            hoursTable = table;
    if (!hoursTable)
        hoursTable = tables[8];
    
    NSArray *rows = [hoursTable childrenWithTagName:@"tr"];
    int count = 0;
    for (TFHppleElement *row in rows) {
        
        if (count>=2) {
            
            TFHppleElement* td = [row firstChildWithTagName:@"td"];
            TFHppleElement* strong = [td firstChildWithTagName:@"strong"];
            NSString *text = [strong firstChildWithTagName:@"text"].content;
            
            [h addHall:text];
            [self setRow:row Named:text ForHours:h];
        }
        count++;
        
    }
    return h;
    
}
- (void)setRow:(TFHppleElement*)row Named:(NSString*)hallName ForHours:(Hours*)h {
    NSArray *meals = [NSArray arrayWithObjects:@"breakfast",@"lunch", @"dinner", nil];
   
    NSArray *td = [row childrenWithTagName:@"td"];
    for (int i = 1; i <=3; i++) {
        TFHppleElement *currentMeal = td[i];
        NSArray *strong = [currentMeal childrenWithTagName:@"strong"];
        
        NSString *opening = [strong[0] firstChildWithTagName:@"text"].content;
        NSDate *openingAsDate = [self dateFromString:opening];
        [h addOpeningTime:openingAsDate ToMeal:meals[i-1] Hall:hallName];
        NSDate *closingAsDate;
        if (openingAsDate){
        NSString *closing = [strong[1] firstChildWithTagName:@"text"].content;
         closingAsDate = [self dateFromString:closing];
        }
        else
        closingAsDate = nil;
        
        [h addClosingTime:closingAsDate ToMeal:meals[i-1] Hall:hallName];
    }

}


- (Meal *)loadDiningDataForMeal:(NSString *)meal Specificity:(Specificity)spec {
    
    Meal *m = [[Meal alloc] initWithName:meal];
    //set hours
    TFHpple *urlData = [self getNodeDataForURL:HOURS];
    Hours *h = [self getHours];
    for (DiningHall *hall in [m.hallList allValues]) {
        NSArray *data = [h getHoursForMeal:meal Hall:hall.name];
        //NSArray *data = [self getHourDataForHall:hall.name Meal:meal data:urlData];
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

- (void) saveStateToDocumentNamed:(NSString*)docName
{
    NSLog(@"saving");
    NSError       *error;
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSArray       *paths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString      *docPath = [paths[0] stringByAppendingPathComponent:docName];
    
    if ([fileMan fileExistsAtPath:docPath])
        [fileMan removeItemAtPath:docPath error:&error];
    
    // Create the dictionary with all the stuff you want to store locally
    
    NSDictionary *state = [NSDictionary dictionaryWithObjectsAndKeys:[self parseHoursFromServer], @"Hours", nil];
    
    // There are many ways to write the state to a file. This is the simplest
    // but lacks error checking and recovery options.
    [NSKeyedArchiver archiveRootObject:state toFile:docPath];
    NSLog(@"end");
}

- (NSDictionary*) stateFromDocumentNamed:(NSString*)docName
{
    NSLog(@"checking cache");
    NSError       *error;
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSArray       *paths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString      *docPath = [paths[0] stringByAppendingPathComponent:docName];
    
    if ([fileMan fileExistsAtPath:docPath])
        return [NSKeyedUnarchiver unarchiveObjectWithFile:docPath];
    
    return nil;
}

@end
