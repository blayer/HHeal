//
//  EbolaRiskViewController.h
//  HHeal
//
//  Created by Changkun Zhao on 10/12/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
@interface EbolaRiskViewController : UIViewController<PNChartDelegate>
@property (nonatomic) PNBarChart *barChart;
@property (weak, nonatomic) IBOutlet UILabel *regionalCase;
@property (weak, nonatomic) IBOutlet UILabel *nationalCase;

@end
