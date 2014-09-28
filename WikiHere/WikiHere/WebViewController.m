//
//  WebViewController.m
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tabBarController.tabBar setHidden:YES];
  [self.navigationController.navigationBar setHidden:NO];
  
  [_toolBar setHidden:YES];
  [_webView setDelegate:self];
  
  //  Set the url string
  _urlString = [NSString stringWithFormat:@"%@=%@",@"http://www.wikipedia.org/wiki/?curid",_pageID];
  
  // Create a URL request
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
  
  // Tell the web view to show it
  [_webView loadRequest:requestObj];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [self.tabBarController.tabBar setHidden:NO];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
  NSMutableArray *toolBarButtons = [[_toolBar items] mutableCopy];
  
  if ([_webView canGoBack]) {
    [_toolBar setHidden:NO];
  }
  
  if ([_webView canGoForward]) {
    [toolBarButtons addObject:_forwardButtonView];
    [_toolBar setItems:toolBarButtons];
  } else {
    [toolBarButtons removeObject:_forwardButtonView];
    [_toolBar setItems:toolBarButtons];
  }
}


- (IBAction)back:(id)sender {
  [_webView goBack];
}

- (IBAction)forward:(id)sender {
  [_webView goForward];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
