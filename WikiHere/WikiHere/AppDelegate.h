//
//  AppDelegate.h
//  WikiHere
//
//  Created by Justin Smith on 9/6/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
