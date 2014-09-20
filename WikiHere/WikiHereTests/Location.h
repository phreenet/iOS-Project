//
//  Location.h
//  WikiHere
//
//  Created by Jeremy on 9/18/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject {
    NSInteger radius;
    double latitude;
    double longitude;
}

@property (nonatomic, readwrite) NSInteger radius;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (id) init;

- (id) initWithInfo: (NSInteger) newRadius : (double) newLatitude : (double) newLongitude;

- (NSString *) generateURL;

@end
