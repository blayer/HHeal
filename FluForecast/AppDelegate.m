//
//  AppDelegate.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/21/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "AppDelegate.h"
#import "BlurryModalSegue/BlurryModalSegue.h"
#import <CoreLocation/CoreLocation.h>
#import "HHealParameter.h"
#import <FacebookSDK/FacebookSDK.h>



@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BlurryModalSegue appearance] setBackingImageBlurRadius:@(20)];
    [[BlurryModalSegue appearance] setBackingImageSaturationDeltaFactor:@(.45)];
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
    
    //self.locationManager.delegate = self;
    //self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //self.locationManager.pausesLocationUpdatesAutomatically = YES;
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    self.lastSentUpdateAt = [NSDate date];
    [self.locationManager startUpdatingLocation];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    
    // Handle location updates as normal, code omitted for brevity.
    // The omitted code should determine whether to reject the location update for being too
    // old, too close to the previous one, too inaccurate and so forth according to your own
    // application design.
    
    if (isInBackground)
    {
        //send to server
        
    }
    else
    {
        if (newLocation.horizontalAccuracy <= 100.0f && [self.lastSentUpdateAt timeIntervalSinceNow] < -10 * 60) {
            // Set date to now
            self.lastSentUpdateAt = [NSDate date];
            
            // Use json and send data to server
            
        }
    }
    
    //this function should handle location changes in two cases.
    // Accuracy is good & 5 minutes have passed.
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
@end
