//
//  RegisterViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 7/28/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *ReEnterPassword;
@property (weak, nonatomic) IBOutlet UITextField *Age;
@property (weak, nonatomic) IBOutlet UITextField *State;

- (IBAction)SelectAge:(id)sender;
- (IBAction)SelectState:(id)sender;

- (IBAction)RegisterProfile:(id)sender;
@end
