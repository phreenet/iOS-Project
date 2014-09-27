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

@interface Location : NSObject {
    int radius;
    MKUserLocation *location;
}

@property (nonatomic, assign) int radius;
@property (nonatomic) MKUserLocation *location;

- (id) init;

- (id) initWithRadius: (int) newRadius newLocation: (MKUserLocation *) newLocation;

- (NSString *) generateURL;

@end
