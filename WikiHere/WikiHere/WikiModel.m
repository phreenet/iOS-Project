//
//  WikiModel.m
//  WikiHere
//
//  Created by Jeremy on 9/27/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "WikiModel.h"

@implementation WikiModel

- (void) searchWikipediaArticlesAroundLocation:(CLLocation *) newLocation
                              withSearchRadius:(NSInteger) radius
{
  //generate URL from location
  NSString *wikiURL = [NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?action=query"
                       @"&list=geosearch"
                       @"&format=xml"
                       @"&gslimit=50"     // TODO: Magic number remove!
                       @"&gsmaxdim=3000"  // TODO: Magic number remove!
                       @"&gsradius=%ld"
                       @"&gscoord=%g|%g",
                       (long)radius, newLocation.coordinate.latitude,
                                     newLocation.coordinate.longitude];
    
  //this code somehow makes the url palateable to WikiPedia
  NSString *url = [wikiURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSLog(@"Calling Wikipedia with URL: %@", url);
  
  //configure the session
  NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  //create the delegate free session because we're using NSNotificationCenter
  NSURLSession *delagateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                    delegate:nil
                                                               delegateQueue:[NSOperationQueue mainQueue]];
  
  [[delagateFreeSession dataTaskWithURL:[NSURL URLWithString:url]
                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
      if (!error) {
        //log response for debugging
        NSLog(@"Got response %@ with error %@\n", response, error);
        
        //now for our fabulous parser
        //this parses into an array of NSDictionary objects
        SHXMLParser     *parser         = [[SHXMLParser alloc] init];
        NSDictionary    *resultObject   = [parser parseData: data];
        NSArray         *dataArray      = [SHXMLParser getDataAtPath:@"api.query.geosearch.gs"
                                                    fromResultObject:resultObject];
        
        //this is an array of strings to match the variable names in
        //WikiEntry class - used by the parser to create the WikiEntry
        //array
        NSArray *classVariables = [NSArray arrayWithObjects:@"pageid", @"title", @"lat", @"lon", @"dist", nil];
        
        //this is a converter array because for some reason I can't just
        //use the RHS in the NSMutableArray "arrayWithArray"
        NSArray *converterArray = [SHXMLParser convertDictionaryArray:dataArray
                                           toObjectArrayWithClassName: @"WikiEntry"
                                                       classVariables:classVariables];
        
        _wikiEntryArray = [NSArray arrayWithArray:converterArray];
        
        
         //uncomment this block to check if the array was successfully created
         //it will log through every entry in the array if creation was
         //successful
         NSLog(@"\nTest Array: \n\n");
         for (WikiEntry *test in _wikiEntryArray) {
           NSLog(@"Title: %@", test.title);
           NSLog(@"pageid: %@", test.pageid);
           NSLog(@"lat: %f", test.lat);
           NSLog(@"lon: %f", test.lon);
           NSLog(@"dist: %ld\n\n", test.dist);
         }
         
        
        //NSDictionary to pass array via NSNotificationCenter
        NSDictionary *theArray = [NSDictionary dictionaryWithObjectsAndKeys:_wikiEntryArray,
                                  @"wikiEntryArray", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Array Complete"
                                                            object:self
                                                          userInfo:theArray];
      }
      else //if there was an error
      {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Array Incomplete"
                                                            object:self];
      }
    }]resume];
}

@end
