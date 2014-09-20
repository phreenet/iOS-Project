//
//  TableViewController.m
//  WikiHere
//
//  Created by drsneed on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "TableViewController.h"
#import "WebViewController.h"



@implementation TableViewController
{
    // There is probably a better way to store the table data. This is just quick and dirty,
    // and due to my lack of Objective-C knowledge, easy to make. -DS
    NSArray* titles;
    NSArray* subtitles;
    NSArray* pageIDs;
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

    // Just initializing the arrays with dummy data for the time being. -DS
    
    titles = [NSArray arrayWithObjects:@"Detroit", @"Chicago", @"New York", nil];
    subtitles = [NSArray arrayWithObjects: @"The Motor City", @"The Windy City", @"The Big Apple", nil];
    pageIDs = [NSArray arrayWithObjects: @"8687", @"6886", @"645042", nil];
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titles count];
}

// IMPORTANT! I could not get the segue to transition to the web view without adding this method
// which manually activates the segue. -DS

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showWikipediaArticle" sender:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Setting text from the titles array.
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    // Setting subtitles from the subtitles array. This doesn't work, haven't had time to figure out why yet...
    cell.detailTextLabel.text = [subtitles objectAtIndex:indexPath.row];
    return cell;
}

// This method is called right before the web view is instantiated -DS
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Here is where we pass the page ID to the Web View Controller.
    if ([[segue identifier] isEqualToString:@"showWikipediaArticle"])
    {
        WebViewController *webViewController =
        [segue destinationViewController];
        
        // Grab the row that was pressed
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        long row = [myIndexPath row];
        
        // Set webViewController's page id accordingly.
        webViewController.pageID = [pageIDs objectAtIndex:row];
    }
}
@end
