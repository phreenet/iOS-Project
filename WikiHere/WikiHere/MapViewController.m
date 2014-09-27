//
//  MapViewController.m
//  WikiHere
//
//  Created by Justin Smith on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "MapViewController.h"
#import "Location.h"
#import "WikiEntry.h"
#import "CallWikipedia.h"
#import "Annotation.h"

@implementation MapViewController

// TODO: Implement map drag update, update articles if moved more than X meters.

// TODO: Fix didUpdateUserLocation so that zoom region doesn't change zoom level if user has
// changed it manually.  Only zoom to default if user presses location button or on app startup.

// TODO: Implement WYPopoverController for settings button.



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  // Get user's location
  CLLocationCoordinate2D currentLocation = [userLocation coordinate];
  
  // Get user location and zoom to that point.
  MKCoordinateRegion region =
  MKCoordinateRegionMakeWithDistance(currentLocation, 10000, 10000);

  [_mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  
  
  
}

- (IBAction)moveToUserLocation:(id)sender
{
  
  // Get user location and zoom to that point.
  MKUserLocation *userLocation = _mapView.userLocation;
  
  MKCoordinateRegion region =
  MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 10000, 10000);
  
  [_mapView setRegion:region animated:YES];
  
  // TODO: This next block is for testing only, need to setup app in such a way that only if
  // last distance was greater
    
    Location *currentLocation = [[Location alloc] initWithRadius:10000 newLocation:userLocation];
  
  
    [CallWikipedia populateArray:currentLocation];
  NSArray *articleList = [CallWikipedia getMainArray];
  
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

- (void)viewDidLoad
{
  [super viewDidLoad];
  _mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
