//
//  MapViewController.m
//  WikiHere
//
//  Created by Justin Smith on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "MapViewController.h"
#import "WebViewController.h"
#import "WikiModel.h"
#import "WikiEntry.h"
#import "Annotation.h"
#import "AppDelegate.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static const int    MAX_DISTANCE_IN_METERS_MOVE_FOR_UPDATE = 5000;
static const double MAX_SPAN_IN_DEGREES_FOR_UPDATE = 0.5;

@interface MapViewController() {
  BOOL firstUpdate; // After first update tone down the accuracy and location change monitoring
  BOOL updateGuard; // updateGuard prevents Wiki update when centering on annotation in MapView
}

@end

@implementation MapViewController

#pragma mark - MapViewDelegate Methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  // Get user's location
  CLLocationCoordinate2D currentPoint = [userLocation coordinate];
  
  CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentPoint.latitude
                                                           longitude:currentPoint.longitude];
  
  
  // If user has moved more than 500 meters recenter map.
  if ([currentLocation distanceFromLocation:_lastUpdateUserLocation] >= 500) {
    _lastUpdateUserLocation = currentLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(currentPoint, 5000, 5000);
    [_mapView setRegion:region animated:YES];
  }
  
  if (firstUpdate) {
    // Set location manager properties for best battery performance.
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    firstUpdate = NO;
  }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  // Get center point of currently displayed region
  CLLocationCoordinate2D centerPoint = [mapView centerCoordinate];
  
  CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerPoint.latitude
                                                          longitude:centerPoint.longitude];

  // Checks to see if we should be updating after this move.
  if ([self shouldUpdateMapAtLocation:centerLocation]) {
    [self updateDataSourceWithLocation:centerLocation];
  }
}

#pragma mark - User Interactions

- (IBAction)moveToUserLocation:(id)sender
{
  
  // Get user location and zoom to that point.
  MKUserLocation *userLocation = [self.mapView userLocation];
  
  MKCoordinateRegion region =
  MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 5000, 5000);
  
  [_mapView setRegion:region animated:YES];
}

- (void)showAnnotationCallout:(NSInteger)annotationIndex
{
  // In a split view application the master (table) can call annotations to callout.
  Annotation *selectedAnnotation = [_annotations objectAtIndex:annotationIndex];
  [_mapView selectAnnotation:selectedAnnotation animated:YES];
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([selectedAnnotation coordinate], 5000, 5000);
  [_mapView setRegion:region animated:YES];
}

#pragma mark - Annotation Delegte

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  // Check to make sure we aren't creating an annotation for the userLocation, we want that
  // blue circle!
  if([annotation isEqual:[mapView userLocation]]) {
    return nil;
  }
  
  // Reuse annotations just like we re-use table cells in a tableview.
 
  MKPinAnnotationView *annotationView = (MKPinAnnotationView *)
  [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapViewAnnotationIdentifier"];
  
  if (annotationView == nil) {
    annotationView  = [[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation
                                     reuseIdentifier:@"mapViewAnnotationIdentifier"];
  }
  
  annotationView.animatesDrop = YES;
  annotationView.canShowCallout = YES;
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  
  return annotationView;
}

#pragma mark - Data/Model Handling

- (void)updateDataSourceWithLocation:(CLLocation *) currentLocation
{
  // Set lastPolledLocation to the one we are about to execute.
  _lastArticleUpdateLocation = currentLocation;
  
  // Notify Model it needs to update the article array.
  [_model searchWikipediaArticlesAroundLocation:currentLocation
                               withSearchRadius:5000];
}

- (BOOL)shouldUpdateMapAtLocation:(CLLocation *) currentLocation
{
  // Check to see if updateGuard is set to YES
  if (updateGuard) {
    updateGuard = NO; // Clear updateGuard
    return NO;
  }
  
  // Check User Zoom Level by reading one of the region spans.
  if (self.mapView.region.span.latitudeDelta > MAX_SPAN_IN_DEGREES_FOR_UPDATE) {
    return NO;
  }
  
  // Check distance to see if we are more than MAX_DIST... from last polled location.
  CLLocationDistance distance = [currentLocation distanceFromLocation:_lastArticleUpdateLocation];
  return distance > MAX_DISTANCE_IN_METERS_MOVE_FOR_UPDATE;
}

#pragma mark - Model Notification Selector

- (void)reloadData:(NSNotification *)notification
{
  NSArray *articleList = [[notification userInfo] objectForKey:@"wikiEntryArray"];
  
  AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  [appDelegate setTableViewStartingArray:articleList];
  
  if(!_annotations) _annotations = [[NSMutableArray alloc] init];
  
  [_mapView removeAnnotations:_annotations]; // Remove all existing pins from map view.
  [_annotations removeAllObjects]; // Make sure array is empty
  
  for(WikiEntry *e in articleList) {
    Annotation *a = [[Annotation alloc] init];
    a.coordinate = CLLocationCoordinate2DMake(e.lat, e.lon);
    a.title = e.title;
    a.subtitle = [NSString stringWithFormat:@"%ld meters",(long)e.dist];
    a.pageID = e.pageid;
    
    [_annotations addObject:a];
  }
  
  [_mapView addAnnotations:_annotations];
}

#pragma mark - Annotation Selection / Segue

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                      calloutAccessoryControlTapped:(UIControl *)control
{
  _segueAnnotation = view.annotation;
  [self performSegueWithIdentifier:@"showWebView" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showWebView"]) {
    WebViewController *webViewController = [segue destinationViewController];
    [webViewController setPageID:[_segueAnnotation pageID]];
  }
}

#pragma mark - Split View Delegate

// The next two methods will hide and show a button that displays the TableView based on
// screen orientation
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
  barButtonItem.title = @"Article List";
  [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
  self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  [self.navigationItem setLeftBarButtonItem:nil animated:YES];
  self.masterPopoverController = nil;
}


#pragma mark - View Loading

// Setup Map View Controller once when app is first lanuched.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  updateGuard = NO;  // Update guard protects against updates when map is centered on annotation
  firstUpdate = YES; // Will be checked at didUpdateUserLocation
  
  // Setup location manager services so device can use GPS.
  
  _locationManager = [[CLLocationManager alloc] init];
  if (IS_OS_8_OR_LATER) {  // New iOS 8 location privacy request method.
    [_locationManager requestWhenInUseAuthorization];
  }

  [_locationManager startUpdatingLocation];
  
  _mapView.delegate = self;
  _model = [[WikiModel alloc] init];
  _lastArticleUpdateLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
  _lastUpdateUserLocation    = [[CLLocation alloc] initWithLatitude:0 longitude:0];
  
  // Add ViewController to notification center to listen for completed updates by model class.
  // call method reloadData when notification is receieved.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadData:)
                                               name:@"Array Complete"
                                             object:_model];
}

- (void)viewWillAppear:(BOOL)animated
{
  // Hide Navigation Bar in iPhone version because we have the TabBar to move between
  // map and list views.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self.navigationController.navigationBar setHidden:YES];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
