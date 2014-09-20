//
//  WebViewController.m
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // All I'm doing here is appending the page id to the wikipedia url. -DS
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.wikipedia.org/wiki/?curid="];
    [urlString appendString:_pageID];
    // Create a URL request
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    // Tell the web view to show it
    [webview loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
