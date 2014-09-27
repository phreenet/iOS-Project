//
//  MapViewController.m
//  WikiHere
//
//  Created by Justin Smith on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "MapViewController.h"
#import "Location.h"
#import "WikiEntry.h"
#import "CallWikipedia.h"
#import "Annotation.h"

static const int    MAX_DISTANCE_IN_METERS_MOVE_FOR_UPDATE = 5000;
static const double MAX_SPAN_IN_DEGREES_FOR_UPDATE = 0.5;

@implementation MapViewController

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  // Get user's location
  CLLocationCoordinate2D currentPoint = [userLocation coordinate];
  
  CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentPoint.latitude
                                                           longitude:currentPoint.longitude];
  
  
  // If user has moved more than 50 meters recenter map.
  if ([currentLocation distanceFromLocation:_lastUpdateUserLocation] >= 50) {
    _lastUpdateUserLocation = currentLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(currentPoint, 10000, 10000);
    [_mapView setRegion:region animated:YES];
  }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  // Get center point of currently displayed region
  CLLocationCoordinate2D centerPoint = [mapView centerCoordinate];
  
  CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerPoint.latitude
                                                          longitude:centerPoint.longitude];
  
  NSLog(@"New region center point: %@", [NSString stringWithFormat:@"%f %f",
                                        centerPoint.latitude, centerPoint.longitude]);
  
  // Checks to see if we should be updating after this move.
  if ([self shouldUpdateMapAtLocation:centerLocation]) {
    NSLog(@"Updating Data Source After Region Change: %@", [NSString stringWithFormat:@"%f %f",
                                                      centerPoint.latitude, centerPoint.longitude]);
    
    [self updateDataSourceWithLocation:centerLocation];
  }
}

- (IBAction)moveToUserLocation:(id)sender
{
  
  // Get user location and zoom to that point.
  MKUserLocation *userLocation = [self.mapView userLocation];
  
  MKCoordinateRegion region =
  MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 10000, 10000);
  
  [_mapView setRegion:region animated:YES];
}


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
  
  return annotationView;
}

- (void)updateDataSourceWithLocation:(CLLocation *) currentLocation
{
  // Set lastPolledLocation to the one we are about to execute.
  _lastArticleUpdateLocation = currentLocation;
  
  // Fetch article list from Wikipedia v1.0 -- OLD WAY - PLEASE STOP.
  Location *location = [[Location alloc] initWithRadius:10000
                  newLocation:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,
                                                         currentLocation.coordinate.longitude)];
  [CallWikipedia populateArray:location];
  NSArray *articleList = [CallWikipedia getMainArray];
  
  // Fetch article list from Wikipedia v2.0 -- NOT WORKING ATM
//  NSArray *articleList = [CallWikipedia searchWikipediaArticlesAroundLocation:currentLocation
//                                                             withSearchRadius:10000];
  
  NSLog(@"%@", [NSString stringWithFormat:@"articleList holds %lu objects",
                (unsigned long)[articleList count]]);
  
  NSMutableArray *annotations = [[NSMutableArray alloc] init];
  
  for(WikiEntry *e in articleList) {
    Annotation *a = [Annotation alloc];
    a.coordinate = CLLocationCoordinate2DMake(e.lat, e.lon);
    a.title = e.title;
    a.subtitle = [NSString stringWithFormat:@"%ld m",(long)e.dist];
    a.pageID = e.pageid;
    
    
    NSLog(@"%@", [NSString stringWithFormat:@"Current Annotation: %@ \n"
                  @"Distance: %@ \n"
                  @"Lattitude: %f \n"
                  @"Longitude: %f \n"
                  @"pageID: %@ \n",
                  a.title, a.subtitle, a.coordinate.latitude, a.coordinate.longitude, a.pageID]);
    
    [annotations addObject:a];
  }
  
  [_mapView addAnnotations:annotations];
}

- (BOOL)shouldUpdateMapAtLocation:(CLLocation *) currentLocation
{
  // Check User Zoom Level by reading one of the region spans. 
  if (self.mapView.region.span.latitudeDelta > MAX_SPAN_IN_DEGREES_FOR_UPDATE) {
    return NO;
  }
  
  // Check distance to see if we are more than MAX_DIST... from last polled location.
  CLLocationDistance distance = [currentLocation distanceFromLocation:_lastArticleUpdateLocation];
  return distance > MAX_DISTANCE_IN_METERS_MOVE_FOR_UPDATE;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _mapView.delegate = self;
  _lastArticleUpdateLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
  _lastUpdateUserLocation    = [[CLLocation alloc] initWithLatitude:0 longitude:0];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
