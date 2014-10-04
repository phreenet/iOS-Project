//
//  TableViewController.m
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "TableViewController.h"
#import "WebViewController.h"
#import "WikiEntry.h"
#import "AppDelegate.h"


@implementation TableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Listen for WikiModel to release updates.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateDataSource:)
                                               name:@"Array Complete"
                                             object:nil];
  
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  _wikiEntries = [appDelegate tableViewStartingArray];
}

-(void)updateDataSource:(NSNotification *)notification
{
  _wikiEntries = [[notification userInfo] objectForKey:@"wikiEntryArray"];
  [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.wikiEntries count];
}


// Sets values for Wikipedia Entry
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleEntryCell"];
  
  
  // Configure the cell...THIS IS IMPORTANT to set text!!
  cell.textLabel.text = [[self.wikiEntries objectAtIndex:indexPath.row] title];
  
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld meters",
                               (long)[[self.wikiEntries objectAtIndex:indexPath.row] dist]];
  return cell;
}

//Perform the segue transition.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Determine if we are on a phone or tablet.  Phones will segue with full screen replace
  // standard option and tablets segue with special replace detail option in storyboard.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self performSegueWithIdentifier:@"showWikipediaArticle" sender:nil];
  } else {
    [self performSegueWithIdentifier:@"SplitViewSegue" sender:nil];
  }
  
}

// This method is called right before the web view is instantiated -DS
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
  // Here is where we pass the page ID to the Web View Controller.
  if ([[segue identifier] isEqualToString:@"showWikipediaArticle"]) {
    _webViewController = [segue destinationViewController];
  } else if ([[segue identifier] isEqualToString:@"SplitViewSegue"]) {
    _webViewController = [segue destinationViewController];
  } else {
    return;
  }
  
  // Grab the row that was pressed
  NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
  long row = [myIndexPath row];
  
  // Set webViewController's pageID based on the selected WikiEntry
  _webViewController.pageID = [[self.wikiEntries objectAtIndex:row] pageid];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
