//
//  CalculatorViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 8/17/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *age;

@property (weak, nonatomic) IBOutlet UITextField *heartRate;
@property (weak, nonatomic) IBOutlet UILabel *display;

- (IBAction)calculateButtonClicked:(id)sender;

@end
