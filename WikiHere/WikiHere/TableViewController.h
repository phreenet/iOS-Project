//
//  TableViewController.h
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewController;

@interface TableViewController : UITableViewController

@property (strong, nonatomic) WebViewController *webViewController;

@property (nonatomic, retain) NSArray *wikiEntries;


@end

//@interface TableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

//@property (strong, nonatomic) UITableView *tableView;

//@end
