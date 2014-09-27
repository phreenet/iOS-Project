//
//  Location.h
//  WikiHere
//
//  Created by Jeremy on 9/18/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject

@property (nonatomic, assign) int radius;
@property (nonatomic) CLLocationCoordinate2D location;


- (id) initWithRadius: (int) newRadius newLocation: (CLLocationCoordinate2D) newLocation;
- (NSString *) generateURL;

@end
