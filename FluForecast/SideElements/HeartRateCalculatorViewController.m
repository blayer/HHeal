//
//  HeartRateCalculatorViewController.m
//  HHeal
//
//  Created by Changkun Zhao on 10/31/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "HeartRateCalculatorViewController.h"

@interface HeartRateCalculatorViewController ()

@end

@implementation HeartRateCalculatorViewController

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

- (IBAction)calculateClick:(id)sender {
    int score=0;
    int switch1=0;
    int switch2=0;
    int switch3=0;
    if ([self.switchValue1 isOn]==YES)
    { switch1=1;}
    if ([self.switchValue2 isOn]==YES)
    { switch2=1;}
    if ([self.switchValue3 isOn]==YES)
    { switch3=1;}
    
    
    if ([self.age.text length]==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No age entered"
                                                            message:@"Please enter your age."                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
}
    else {
    
        int age= [self.age.text intValue];
        score =(180-age-10*switch1-5*switch2+5*(1-switch1)*(1-switch2)*switch3)*0.75;
       NSString *scoreString = [NSString stringWithFormat:@"%d",score];
        [self.heartRate setText:scoreString];
        
    }
    
    
}
@end
