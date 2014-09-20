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

@implementation MapViewController

@synthesize lastLocation;

// TODO: Implement map drag update, update articles if moved more than X meters.

// TODO: Fix didUpdateUserLocation so that zoom region doesn't change zoom level if user has changed it manually.  Only zoom to default if user presses location button or on app startup.

// TODO: Implement WYPopoverController for settings button.

- (void)viewDidLoad
{
  [super viewDidLoad];
  _mapView.showsUserLocation = YES;
  _mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  // Get user location and zoom to that point.
  MKCoordinateRegion region =
  MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 10000, 10000);
  
  [_mapView setRegion:region animated:YES];
//  _mapView.centerCoordinate = userLocation.location.coordinate;
  

}




- (IBAction)moveToUserLocation:(id)sender {
  
  // Get user location and zoom to that point.
  MKUserLocation *userLocation = _mapView.userLocation;
  
  MKCoordinateRegion region =
  MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 10000, 10000);
  
  [_mapView setRegion:region animated:YES];
  
  // TODO: This next block is for testing only, need to setup app in such a way that only if last distance was greater
  
  Location *currentLocation = [[Location alloc] initWithInfo:10000
                                                            :userLocation.coordinate.latitude
                                                            :userLocation.coordinate.longitude];
  
  
  NSArray *articleList = [CallWikipedia populateArray:currentLocation];
  
  NSMutableArray *annotations = [[NSMutableArray alloc] init];  
  
  for(WikiEntry *e in articleList) {
    Annotation *a = [Annotation alloc];
    a.coordinate = CLLocationCoordinate2DMake(e.lat, e.lon);
    a.title = e.title;
    a.subtitle = [NSString stringWithFormat:@"%ld",(long)e.dist];
    
    [annotations addObject:a];
  }
  
  [_mapView addAnnotations:annotations];
  
  
  
  
}

@end
