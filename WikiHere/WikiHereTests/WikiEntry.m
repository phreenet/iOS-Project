//
//  WikiEntry.m
//  WikiHere
//
//  Created by Jeremy on 9/18/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "WikiEntry.h"

@implementation WikiEntry

@synthesize pageid, title, lat, lon, dist;

- (id) init {
    pageid = @"";
    title = @"";
    lat = 0;
    lon = 0;
    dist = 0;
    return self;
}

- (id) initWithInfo: (NSString *) newPageID : (NSString *) newTitle : (double) newEntryLatitude : (double) newEntryLongitude : (NSInteger) newDistanceFromLocation

{
    self = [super init];
    if (self) {
        self.pageid = newPageID;
        self.title = newTitle;
        self.lat = newEntryLatitude;
        self.lon = newEntryLongitude;
        self.dist = newDistanceFromLocation;
    }
    
    return self;
}

@end
