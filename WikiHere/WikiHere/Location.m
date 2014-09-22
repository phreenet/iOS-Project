//
//  Location.m
//  WikiHere
//
//  Created by Jeremy on 9/18/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize radius, latitude, longitude;

- (id) init {
    radius = 0;
    latitude = 0;
    longitude = 0;
    return self;
}

- (id) initWithInfo: (NSInteger) newRadius : (double) newLatitude : (double) newLongitude {
    self = [super init];
    if (self) {
        self.radius = newRadius;
        self.latitude = newLatitude;
        self.longitude = newLongitude;
    }
    return self;
}

- (NSString *) generateURL {
    
    NSString *wikiURL = [NSString stringWithFormat:@"https://en.wikipedia.org/w/api.php?action=query&list=geosearch&gsradius=%d&gscoord=%g|%g&format=xml",radius, latitude, longitude];
    
    NSString *url = [wikiURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return url;

}

@end
