//
//  ReportFluViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 8/14/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ReportFluViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *feverSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *coughSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sourSwitch;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (nonatomic) BOOL fluReported;
- (IBAction)reportButtonClicked:(id)sender;

@end
