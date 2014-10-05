//
//  BarChartViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 7/25/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"


@interface BarChartViewController : UIViewController <PNChartDelegate>

@property (nonatomic) PNBarChart *barChart;
- (IBAction)sendLocation:(id)sender;

@end
