//
//  AppDelegate.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/21/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "HHealParameter.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "BlurryModalSegue/BlurryModalSegue.h"


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BlurryModalSegue appearance] setBackingImageBlurRadius:@(20)];
    [[BlurryModalSegue appearance] setBackingImageSaturationDeltaFactor:@(.45)];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =[defaults valueForKey:@"token"];

    self.locationManager.delegate = self;
    [self.locationManager stopUpdatingLocation];
    if(![token length]==0)
    { [self.locationManager startMonitoringSignificantLocationChanges];}
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =[defaults valueForKey:@"token"];
    
    self.locationManager.delegate=self;
    [self.locationManager stopMonitoringSignificantLocationChanges];
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter=50;
    if(![token length]==0)
    {[self.locationManager startUpdatingLocation];}
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [FBSession.activeSession close];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSString *token =[defaults valueForKey:@"token"];
     NSMutableString *url=[NSMutableString new];
     [url appendString:HHealURL];
     [url appendString:@"/user_location/"];
     if(token!=nil)
     {[url appendString:token];}
     CLLocation *location =[manager location];
     
     NSString *lat =[NSString stringWithFormat:@"%f", location.coordinate.latitude];
     NSString *lng =[NSString stringWithFormat:@"%f", location.coordinate.longitude];
     NSDictionary *parameters=@{@"lng":lng,@"lat":lat};
    
    NSLog(@"Coordinate: %@", parameters);

    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];


}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
@end
