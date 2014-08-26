//
//  CalculatorViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/17/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.age resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)calculateButtonClicked:(id)sender {
 
    int agePara=[self.age.text intValue ];
    int ratePara=[self.heartRate.text intValue];
    
    int max= 15.3*((208-(agePara*0.7))/(ratePara*3));
    
    NSString *MaxValue = [NSString stringWithFormat:@"%d",max];
    [ self.display setText:MaxValue];
}
@end
