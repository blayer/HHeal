//
//  AppDelegate.h
//  FluForecast
//
//  Created by Changkun Zhao on 7/21/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) NSDate *lastSentUpdateAt;
@end
