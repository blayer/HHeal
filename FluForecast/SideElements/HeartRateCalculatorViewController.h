//
//  HeartRateCalculatorViewController.h
//  HHeal
//
//  Created by Changkun Zhao on 10/31/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartRateCalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *heartRate;
@property (weak, nonatomic) IBOutlet UISwitch *switchValue1;
@property (weak, nonatomic) IBOutlet UISwitch *switchValue2;
@property (weak, nonatomic) IBOutlet UISwitch *switchValue3;
@property (weak, nonatomic) IBOutlet UITextField *age;
- (IBAction)calculateClick:(id)sender;

@end
