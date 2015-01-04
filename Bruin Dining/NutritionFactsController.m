//
//  NutritionFactsController.m
//  Bruin Bites
//
//  Created by Mahir Eusufzai on 1/2/15.
//  Copyright (c) 2015 Mahir Eusufzai. All rights reserved.
//

#import "NutritionFactsController.h"

@interface NutritionFactsController ()

@end

@implementation NutritionFactsController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    webViewFinishedLoading = NO;
    loadFailed = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    loadFailed = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (!loadFailed)
    {
        webViewFinishedLoading = YES;
        [_spinner stopAnimating];
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_webview setDelegate:self];
    [_spinner startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.link];
    [_webview loadRequest:request];

}

@end
