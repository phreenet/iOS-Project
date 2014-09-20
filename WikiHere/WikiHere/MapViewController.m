//
//  MapViewController.m
//  WikiHere
//
//  Created by Justin Smith on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "MapViewController.h"

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
  
  
}

@end
