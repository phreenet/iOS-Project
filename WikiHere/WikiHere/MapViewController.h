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
#import "WikiModel.h"


@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) WikiModel  *model;
@property (strong, nonatomic) NSMutableArray *annotations;  // TODO: Check to see if we can make this non-mutable
@property (strong, nonatomic) CLLocation *lastArticleUpdateLocation;
@property (strong, nonatomic) CLLocation *lastUpdateUserLocation;


- (IBAction)moveToUserLocation:(id)sender;

@end
