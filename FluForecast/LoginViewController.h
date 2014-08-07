//
//  LoginViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 7/29/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTF;

@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)SignIn:(id)sender;


@end
