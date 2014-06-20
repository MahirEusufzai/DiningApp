//
//  ViewController.m
//  Bruin Dining
//
//  Created by Mahir Eusufzai on 3/30/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
   
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    MenuTableController *vc = [segue destinationViewController];

    if ([[segue identifier] isEqualToString:@"pushBreakfast"])
        vc.currentMeal = @"breakfast";
    if ([[segue identifier] isEqualToString:@"pushLunch"])
        vc.currentMeal = @"lunch";
    if ([[segue identifier] isEqualToString:@"pushDinner"])
        vc.currentMeal = @"dinner";
        
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
