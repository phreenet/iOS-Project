//
//  WebViewController.h
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NSString *pageID;
@end
