//
//  WikiEntry.h
//  WikiHere
//
//  Created by Jeremy on 9/18/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiEntry : NSObject {
    
    NSString *pageid;
    NSString *title;
    double lat;
    double lon;
    NSInteger dist;
    
}

@property (nonatomic, retain) NSString *pageid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic) double lat;
@property (nonatomic) double lon;
@property (nonatomic, readwrite) NSInteger dist;

- (id) init;

- (id)initWithInfo: (NSString *) newPageID : (NSString *) newTitle : (double) newEntryLatitude : (double) newEntryLongitude : (NSInteger) newDistanceFromLocation;

@end
