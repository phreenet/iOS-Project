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



+ (void) populateArray: (Location *) newLocation
{
    
    
    Location *location = newLocation;
    
    NSString *url = [location generateURL];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    [[delegateFreeSession dataTaskWithURL: [NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            //log response
            //NSLog(@"Got response %@ with error %@.\n", response, error);
            
            //log data
            //NSLog(@"DATA:\n%@\nEND DATA\n", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
            
            //yee hah this parser is awesome!
            SHXMLParser *parser = [[SHXMLParser alloc] init];
            NSDictionary    *resultObject   = [parser parseData: data];
            NSArray         *dataArray      = [SHXMLParser getDataAtPath:@"api.query.geosearch.gs" fromResultObject:resultObject];
            
           // NSLog(@"dataArray: \n%@", dataArray);
            
            NSArray *classVariables = [NSArray arrayWithObjects:@"pageid", @"title", @"lat", @"lon", @"dist", nil];
            
            NSArray *mainArray = [[NSArray alloc] init];
            
            mainArray = [SHXMLParser convertDictionaryArray:dataArray toObjectArrayWithClassName: @"WikiEntry" classVariables:classVariables];
            
            NSLog(@"\nTest Array: \n\n");
            
            for (WikiEntry *test in mainArray) {
                NSLog(@"Title: %@", test.title);
                NSLog(@"pageid: %@", test.pageid);
                NSLog(@"lat: %f", test.lat);
                NSLog(@"lon: %f", test.lon);
                NSLog(@"dist: %d\n\n", test.dist);
            }
            
            
        }]resume];
    
}




@end
