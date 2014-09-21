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
  // There is probably a better way to store the table data. This is just quick and dirty,
  // and due to my lack of Objective-C knowledge, easy to make. -DS
  //NSArray* titles;
  //NSArray* subtitles;
  //NSArray* pageIDs;
  
 // NSMutableArray *pageIDs = [[NSMutableArray alloc] init];
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
  
  // Just initializing the arrays with dummy data for the time being. -DS
  
  //titles = [NSArray arrayWithObjects:@"Detroit", @"Chicago", @"New York", nil];
  //subtitles = [NSArray arrayWithObjects: @"The Motor City", @"The Windy City", @"The Big Apple", nil];
  //pageIDs = [NSArray arrayWithObjects: @"8687", @"6886", @"645042", nil];
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"ArticleEntryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  if(cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  // Configure the cell...THIS IS IMPORTANT to set text!!
  cell.textLabel.text = [[self.wikiEntries objectAtIndex:indexPath.row] title];
  cell.detailTextLabel.text = [[self.wikiEntries objectAtIndex:indexPath.row] pageid];
  
  return cell;
}

// IMPORTANT! I could not get the segue to transition to the web view without adding this method
// which manually activates the segue. -DS

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"showWikipediaArticle" sender:nil];
  //_webViewController.pageID = [[self.wikiEntries objectAtIndex:indexPath.row] pageID];
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
    
    // Set webViewController's page id accordingly.
    _webViewController.pageID = [[self.wikiEntries objectAtIndex:row] pageid];
    
    
    //webViewController.pageID = [pageIDs objectAtIndex:row];
  }
}

@end
