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
                       @"&list=geosearch" // Asking Wikipedia to do a geosearch
                       @"&format=xml"     // Make sure the format is XML
                       @"&gslimit=50"     // Limit articles to return, hard set to 50
                       @"&gsmaxdim=3000"  // Limit articles to Wikipedia geo dimension size, hard set to 3000
                       @"&gsradius=%ld"   // Max search radius
                       @"&gscoord=%g|%g", // Lat/Long to conduct search around
                       (long)radius, newLocation.coordinate.latitude,
                                     newLocation.coordinate.longitude];
    
  // Convert special characters to their escaped values
  NSString *url = [wikiURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  // Configur a URL Session
  NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  // Create a delegate free session because we're using NSNotificationCenter
  NSURLSession *delagateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                    delegate:nil
                                                               delegateQueue:[NSOperationQueue mainQueue]];
  
  [[delagateFreeSession dataTaskWithURL:[NSURL URLWithString:url]
                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
      if (!error) {
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
