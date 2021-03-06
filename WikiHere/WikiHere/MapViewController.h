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
#import "Annotation.h"


@interface MapViewController : UIViewController <MKMapViewDelegate,
                                                 UISplitViewControllerDelegate,
                                                 CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) WikiModel  *model;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastArticleUpdateLocation;
@property (strong, nonatomic) CLLocation *lastUpdateUserLocation;
@property (strong, nonatomic) Annotation *segueAnnotation;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;


- (IBAction)moveToUserLocation:(id)sender;

- (void)showAnnotationCallout:(NSInteger)annotationIndex;

@end
