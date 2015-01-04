//
//  NutritionFactsController.h
//  Bruin Bites
//
//  Created by Mahir Eusufzai on 1/2/15.
//  Copyright (c) 2015 Mahir Eusufzai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NutritionFactsController : UIViewController <UIWebViewDelegate>

{
    BOOL webViewFinishedLoading, loadFailed;
    
}
@property (nonatomic, retain) NSURL *link;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIWebView *webview;

@end
