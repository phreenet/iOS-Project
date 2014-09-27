//
//  WikiModel.h
//  WikiHere
//
//  Created by Jeremy on 9/27/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "WikiEntry.h"
#import "SHXMLParser/SHXMLParser.h"

@interface WikiModel : NSObject

@property (nonatomic, readonly) NSMutableArray *wikiEntryArray;

- (void) searchWikipediaArticlesAroundLocation: (CLLocation *) newLocation
               withSearchRadius: (NSInteger) radius;

@end
