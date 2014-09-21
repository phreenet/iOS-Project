//
//  CallWikipedia.m
//  tableViewApp
//
//  Created by Jeremy on 9/19/14.
//  Copyright (c) 2014 Maurerhouse, LLC. All rights reserved.
//

#import "CallWikipedia.h"
#import "SHXMLParser.h"
#import "WikiEntry.h"



@implementation CallWikipedia



+ (NSArray *) populateArray: (Location *) newLocation
{
    
    Location *location = newLocation;
    
    NSString *wikiURL = [location generateURL];
    NSURL *url = [NSURL URLWithString:wikiURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    //yee hah this parser is awesome!
    //
    SHXMLParser *parser = [[SHXMLParser alloc] init];
    NSDictionary    *resultObject   = [parser parseData: data];
    NSArray         *dataArray      = [SHXMLParser getDataAtPath:@"api.query.geosearch.gs" fromResultObject:resultObject];
    
    NSArray *classVariables = [NSArray arrayWithObjects:@"pageid", @"title", @"lat", @"lon", @"dist", nil];
    
    NSArray *mainArray = [[NSArray alloc] init];
    
    mainArray = [SHXMLParser convertDictionaryArray:dataArray toObjectArrayWithClassName: @"WikiEntry" classVariables:classVariables];
    
    
    /*
    NSLog(@"\nTest Array: \n\n");
    
     //this just logs through the array to ensure it's built properly
    for (WikiEntry *test in mainArray) {
        NSLog(@"Title: %@", test.title);
        NSLog(@"pageid: %@", test.pageid);
        NSLog(@"lat: %f", test.lat);
        NSLog(@"lon: %f", test.lon);
        NSLog(@"dist: %d\n\n", test.dist);
    } */
    
    return mainArray;
}




@end
