//
//  WikiArticle.h
//  WikiHere
//
//  Created by Justin Smith on 9/23/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

////// THIS IS FOR CORE DATA TESTING
////// DON'T TOUCH THIS !


@interface WikiArticle : NSManagedObject

@property (nonatomic, retain) NSNumber * articleDistance;
@property (nonatomic, retain) NSNumber * articleLattitude;
@property (nonatomic, retain) NSNumber * articleLongitude;
@property (nonatomic, retain) NSString * articlePageID;
@property (nonatomic, retain) NSString * articleTitle;

@end
