//
//  TableViewController.m
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "TableViewController.h"
#import "WebViewController.h"
#import "CallWikipedia.h"
#import "Location.h"
#import "WikiEntry.h"


@interface TableViewController() {
  
}

@end

@implementation TableViewController
{
  
}

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
  
  // Sets the location.  This will be dynamic in later phase
  Location *location = [[Location alloc] initWithInfo:1000 :37.786971 : -122.399677];
  
  // Calls populateArray method and fills the wikiEntries array
  _wikiEntries = [[NSMutableArray alloc] initWithArray:[CallWikipedia populateArray:location]];
};

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.wikiEntries count];
}


// Sets values for Wikipedia Entry
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleEntryCell"];
  
  
  // Configure the cell...THIS IS IMPORTANT to set text!!
  cell.textLabel.text = [[self.wikiEntries objectAtIndex:indexPath.row] title];
  cell.detailTextLabel.text = [[self.wikiEntries objectAtIndex:indexPath.row] pageid];
  
  return cell;
}

//Perform the segue transition.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"showWikipediaArticle" sender:nil];
}


// This method is called right before the web view is instantiated -DS
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
  // Here is where we pass the page ID to the Web View Controller.
  if ([[segue identifier] isEqualToString:@"showWikipediaArticle"])
  {
    _webViewController =[segue destinationViewController];
    
    // Grab the row that was pressed
    NSIndexPath *myIndexPath = [self.tableView
                                indexPathForSelectedRow];
    long row = [myIndexPath row];
    
    // Set webViewController's pageID based on the selected WikiEntry
    _webViewController.pageID = [[self.wikiEntries objectAtIndex:row] pageid];
    
  }
}

@end
