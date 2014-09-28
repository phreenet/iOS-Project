//
//  WebViewController.h
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButtonView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButtonView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flexBar;

@property (nonatomic) NSString *pageID;
@property (strong, nonatomic) NSString *urlString;

- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;


@end
