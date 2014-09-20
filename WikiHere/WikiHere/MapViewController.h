//
//  MapViewController.h
//  WikiHere
//
//  Created by Justin Smith on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

// TODO: Make MapViewController a delegate of the article list model.

@property (nonatomic) CLLocationCoordinate2D *lastLocation;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)moveToUserLocation:(id)sender;

@end
