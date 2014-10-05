//
//  AppDelegate.m
//  WikiHere
//
//  Created by Justin Smith on 9/6/14.
//  Copyright (c) 2014 CMSC 495. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "TableViewController.h"

@implementation AppDelegate

@synthesize tableViewStartingArray;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Check to see if we are on an iPad.  If we are build a Split View Controller out of the
  // Storyboard Views.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {

    // Create a generic split view controller.
    _splitViewController = [[UISplitViewController alloc] init];
    
    // Create both view controllers and make sure they are embedded in a Generic Navigation controller! A must!
    TableViewController *articleList = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil]
                                        instantiateViewControllerWithIdentifier:@"ArticleList"];
    
    UINavigationController *master = [[UINavigationController alloc] initWithRootViewController:articleList];
    
    MapViewController *mapView = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil]
                                  instantiateViewControllerWithIdentifier:@"MapView"];
    
    UINavigationController *detail = [[UINavigationController alloc] initWithRootViewController:mapView];
    
    
    // Set the MapViewController as the SplitViewController Delegate, it is always displayed so
    // it controls if the button to show/hide the master navigation is shown based on screen orientation
    [_splitViewController setDelegate:mapView];
    
    // Add views and their controllers to the split view hierarchy array and then set the
    // app's root view controller as this new split view controller instead of the storyboards
    // tab bar view controller
    [_splitViewController setViewControllers:[NSArray arrayWithObjects:master, detail, nil]];
    self.window.rootViewController = _splitViewController;
  }
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
}

@end
