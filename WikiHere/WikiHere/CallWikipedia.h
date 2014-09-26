//
//  CallWikipedia.h
//  tableViewApp
//
//  Created by Jeremy on 9/19/14.
//  Copyright (c) 2014 Maurerhouse, LLC. All rights reserved.
//

/*
 How to use the method:
 
 //create an instance of Location with radius, lat, and lon
 
 Location *location = [[Location alloc] initWithInfo:1000 :37.786971 : -122.399677];
 
 //initialize your array with a call to [CallWikipedia populateArray:location]
 //wikiEntries in this example is an array in the ViewController
 //Once the array is created use it to populate the views
 wikiEntries = [[NSMutableArray alloc] initWithArray:[CallWikipedia populateArray:location]];*/

#import <Foundation/Foundation.h>
#import "Location.h"
#import "WikiEntry.h"

@interface CallWikipedia : NSObject


+ (void) populateArray: (Location *) newLocation;
+ (NSArray *) getMainArray;




@end
