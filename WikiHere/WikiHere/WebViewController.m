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
  
  //  Set the url string
  _urlString = [NSString stringWithFormat:@"%s=%@","http://www.wikipedia.org/wiki/?curid",_pageID];
  
    // Create a URL request
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
  // Tell the web view to show it
  [_webView loadRequest:requestObj];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
  if ([_webView canGoBack] == YES){
    [_webView goBack];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"This web page cannot go back" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
    [alert show];
  }
}

- (IBAction)forward:(id)sender {
  if ([_webView canGoForward] == YES){
    [_webView goForward];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"This web page cannot go forward" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
    [alert show];
  }
}
@end
