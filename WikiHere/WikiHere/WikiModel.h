//
//  WikiModel.h
//  WikiHere
//
//  Created by Jeremy on 9/27/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WikiEntry.h"
#import "SHXMLParser/SHXMLParser.h"

@interface WikiModel : NSObject

@property (strong, nonatomic) NSArray *wikiEntryArray;

- (void) searchWikipediaArticlesAroundLocation:(CLLocation *) newLocation
                              withSearchRadius:(NSInteger) radius;

@end
