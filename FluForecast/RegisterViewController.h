//
//  RegisterViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 7/28/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *ReEnterPassword;
@property (weak, nonatomic) IBOutlet UITextField *Age;

- (IBAction)RegisterProfile:(id)sender;
@end
