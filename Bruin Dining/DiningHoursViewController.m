//
//  DiningHoursViewController.m
//  Bruin Dining
//
//  Created by William Gu on 6/25/14.
//  Copyright (c) 2014 Mahir Eusufzai. All rights reserved.
//

#import "DiningHoursViewController.h"

@interface DiningHoursViewController ()
{
    BOOL webViewDidFinishLoad;
    BOOL loadFailed;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation DiningHoursViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    webViewDidFinishLoad = NO;
    loadFailed = NO;
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    loadFailed = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (!loadFailed)
    {
        webViewDidFinishLoad = YES;
        [self.spinner stopAnimating];
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_webView setDelegate:self];
    // Do any additional setup after loading the view.
    //self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
    [_spinner startAnimating];
    NSString *address = @"https://secure5.ha.ucla.edu/restauranthours/dining-hall-hours-by-day.cfm"; //@"http://m.dining.ucla.edu/restaurant-hours.cfm";
    NSURL *url = [NSURL URLWithString:address];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
