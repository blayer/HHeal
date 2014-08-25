//
//  LineChartViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 7/25/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface LineChartViewController : UIViewController <PNChartDelegate>
- (IBAction)Button1Clicked:(id)sender;
- (IBAction)Button2Clicked:(id)sender;
- (IBAction)Button3Clicked:(id)sender;
- (IBAction)Button4Clicked:(id)sender;

@end
