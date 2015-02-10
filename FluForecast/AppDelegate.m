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

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)



@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 480)
    {
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"MainBoard_4s" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    }
    
    if (iOSDeviceScreenSize.height == 568)
    {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"MainBoard" bundle:nil];
        
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    [[BlurryModalSegue appearance] setBackingImageBlurRadius:@(20)];
    [[BlurryModalSegue appearance] setBackingImageSaturationDeltaFactor:@(.45)];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    { //init all default parameter
        int daily=9;
        int interval=5;
        [[NSUserDefaults standardUserDefaults] setInteger:daily forKey:@"daily"];
        [[NSUserDefaults standardUserDefaults] setInteger:interval forKey:@"interval"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"personalrate"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"standardrate"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"numberofselected"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"numberofcompleted"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =[defaults valueForKey:@"token"];
    self.locationManager.delegate = self;
    [self.locationManager stopUpdatingLocation];
    if(![token length]==0)
    { [self.locationManager startMonitoringSignificantLocationChanges];}
// setting fire date
    
    int daily=[defaults integerForKey:@"daily"];
    int interval=[defaults integerForKey:@"interval"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay: 3];
    [components setMonth: 7];
    [components setYear: 2014];
    [components setHour: daily];
    [components setMinute: 0];
    [components setSecond: 0];
    [calendar setTimeZone: [NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];

//adding notifications
    NSString *localrisk=[[NSUserDefaults standardUserDefaults] objectForKey:@"standardrate"];
    NSString *personalrisk=[[NSUserDefaults standardUserDefaults] objectForKey:@"personalrate"];
    NSString *dailyMessage=[NSString stringWithFormat:@"Today, your local flu risk is %@, your personal risk is %@",localrisk,personalrisk];
    
    UILocalNotification *dailynotification = [[UILocalNotification alloc]init];
    [dailynotification setAlertBody:dailyMessage];
    [dailynotification setFireDate:dateToFire];
    [dailynotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [dailynotification setRepeatInterval:kCFCalendarUnitDay];
    [application setScheduledLocalNotifications:[NSArray arrayWithObject:dailynotification]];
    
    int numberofselected=[[NSUserDefaults standardUserDefaults] integerForKey:@"numberofselected"];
    int numberofcompleted=[[NSUserDefaults standardUserDefaults] integerForKey:@"numberofcompleted"];
    int numberofleft=numberofselected-numberofcompleted;
    
    NSString *reminderMessage=[NSString stringWithFormat:@"You have %d training card left today. Carry on!",numberofleft];
    
    UILocalNotification *remindnotification = [[UILocalNotification alloc]init];
    [remindnotification setAlertBody:reminderMessage];
    if(interval!=0)
    { int timeInterval=3600*interval;
    [remindnotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
    [remindnotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [application setScheduledLocalNotifications:[NSArray arrayWithObject:remindnotification]];
    }
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
    if(IS_OS_8_OR_LATER){
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];// For foreground access
    }
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter=50;
    [self.locationManager startUpdatingLocation];
    
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
     if([token length]!=0)
     {[url appendString:token];}
     CLLocation *location =[manager location];
     
     NSString *lat =[NSString stringWithFormat:@"%f", location.coordinate.latitude];
     NSString *lng =[NSString stringWithFormat:@"%f", location.coordinate.longitude];
     NSDictionary *parameters=@{@"lng":lng,@"lat":lat};
    
    NSLog(@"Coordinate: %@", parameters);
    if([token length]!=0){
        
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    }

}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
@end
