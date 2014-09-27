//
//  Location.m
//  WikiHere
//
//  Created by Jeremy on 9/18/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "Location.h"


@implementation Location

- (id) init {
    _radius = 0;
    return self;
}

- (id) initWithRadius:(int)newRadius newLocation:(CLLocationCoordinate2D)newLocation {
    self = [super init];
    if (self) {
        self.radius   = newRadius;
        self.location = newLocation;
    }
    return self;
}

- (NSString *) generateURL {
    
    NSString *wikiURL = [NSString stringWithFormat:@"https://en.wikipedia.org/w/api.php?action=query&list=geosearch&gsradius=%d&gscoord=%g|%g&format=xml", _radius,
                         _location.latitude, _location.longitude];
    
    NSString *url = [wikiURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return url;

}

@end
