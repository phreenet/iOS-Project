//
//  CallWikipedia.m
//  tableViewApp
//
//  Created by Jeremy on 9/19/14.
//  Copyright (c) 2014 Maurerhouse, LLC. All rights reserved.
//

#import "CallWikipedia.h"
#import "WikiEntry.h"
#import <SHXMLParser/SHXMLParser.h>

static NSArray *mainArray;

@implementation CallWikipedia

+ (void) populateArray: (Location *) newLocation
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
    
    mainArray = [[NSArray alloc] init];
    
    mainArray = [SHXMLParser convertDictionaryArray:dataArray toObjectArrayWithClassName: @"WikiEntry" classVariables:classVariables];
    
    
    
//    NSLog(@"\nTest Array: \n\n");
//    for (WikiEntry *test in mainArray) {
//        NSLog(@"Title: %@", test.title);
//        NSLog(@"pageid: %@", test.pageid);
//        NSLog(@"lat: %f", test.lat);
//        NSLog(@"lon: %f", test.lon);
//        NSLog(@"dist: %d\n\n", test.dist);
//    }
  
}

/*
 * Currently a little buggy.  Do not use just yet.
 * You have been warned! JS
 */
+(NSArray *) searchWikipediaArticlesAroundLocation:(CLLocation *)location
                                  withSearchRadius:(NSInteger)radius;
{
  __block NSData *curlResponse;
  __block BOOL error = NO;
  
  NSString *url = [[NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query"
                         @"&list=geosearch"
                         @"&gslimit=50"     // TODO: Magic number remove!
                         @"&gsmaxdim=3000"  // TODO: Magic number remove!
                         @"&gsradius=%ld"
                         @"&gscoord=%g|%g",
                         radius, location.coordinate.latitude, location.coordinate.longitude]
                      stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSLog(@"Current URL request starting: %@", url);
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  NSOperationQueue  *queue = [[NSOperationQueue alloc] init];
  
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:queue
                         completionHandler:^(NSURLResponse *response,
                                             NSData *data,
                                             NSError *connectionError) {
                           if (connectionError) {
                             error = YES;
                           } else {
                             curlResponse = data;
                           }
                         }];
  
  if (!error) {
    SHXMLParser     *parser         = [[SHXMLParser alloc] init];
    NSDictionary    *resultObject   = [parser parseData: curlResponse];
    NSArray         *dataArray      = [SHXMLParser getDataAtPath:@"api.query.geosearch.gs"
                                                fromResultObject:resultObject];
    
    NSArray *classVariables = [NSArray arrayWithObjects:@"pageid", @"title", @"lat", @"lon", @"dist", nil];
    
    mainArray = [[NSArray alloc] init];
    
    mainArray = [SHXMLParser convertDictionaryArray:dataArray
                         toObjectArrayWithClassName: @"WikiEntry"
                                     classVariables:classVariables];
    
    return dataArray; // Using method like this will probably still block UI thread until
                      // Notification Center is setup for pushing it.  UI VC will wait for return!
    
  } else {
    return nil;
  }
}

+ (NSArray *) getMainArray {
    return mainArray;
}


@end
