//
//  MapViewController.h
//  WikiHere
//
//  Created by Justin Smith on 9/19/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MapViewController : UIViewController <MKMapViewDelegate>

// TODO: Make MapViewController a delegate of the article list model.

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) CLLocation *lastPolledLocation;
@property (nonatomic) CLLocation *currentRegionCenterPoint;


- (IBAction)moveToUserLocation:(id)sender;

@end
