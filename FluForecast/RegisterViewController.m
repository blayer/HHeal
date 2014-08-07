//
//  RegisterViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/28/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "RegisterViewController.h"
@interface RegisterViewController ()
@property UIAlertView *PasswordNotMatch;
@property UIAlertView *alertIncorretAge;
@property UIAlertView *alertBlankText;
@property UIAlertView *alertPasswordNotLong;
@property NSInteger SelectedIndex;
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.PasswordNotMatch= [[UIAlertView alloc] initWithTitle:@"Password Not Match" message:@"Please re-enter your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        self.alertBlankText= [[UIAlertView alloc] initWithTitle:@"Blank text" message:@"Please fill all blank text" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    self.alertPasswordNotLong= [[UIAlertView alloc] initWithTitle:@"Password not long enough" message:@"Please re-enter your password(at least 6 charactors or numbers)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        self.alertIncorretAge= [[UIAlertView alloc] initWithTitle:@"Age not sufficient" message:@"Please re-enter your age (0~99)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    
    
    // Do any additional setup after loading the view.
    
    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.UserName resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) isPasswordMatch {
    
if([self.Password.text isEqualToString:self.ReEnterPassword.text])
    return YES;
    else
        return NO;
//here register new users to server
}


-(BOOL) isBlankText{
    if (self.UserName.text.length>0&&self.Email.text.length>0&&self.Password.text.length>0&&self.ReEnterPassword.text.length>0)
        return NO;
    else return YES;

}

-(BOOL) isCorrectAge
{
  if  (self.Age.text.intValue>99 || self.Age.text.intValue<0)
      return NO;
    else
        return YES;
     
}

-(BOOL) isPasswordLongEnough
{ if (self.Password.text.length<6||self.ReEnterPassword.text.length<6)
    return NO;
else return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showAlertMessage
{
if ([self isBlankText])
{ [self.alertBlankText show];
}
else
{if (![self isCorrectAge])
    [self.alertIncorretAge show];
    else
    {
        if (![self isPasswordLongEnough]) {
            [self.alertPasswordNotLong show];
        }
        else {
        if(![self isPasswordMatch])
            [self.PasswordNotMatch show];
            
        }
       
    }
    
    }
}

- (IBAction)RegisterProfile:(id)sender {

    if(![self isBlankText]&&[self isCorrectAge]&&[self isPasswordLongEnough]&&[self isPasswordMatch])
    {
    //send registeration information 
    }
    
    else [self showAlertMessage];


    
}


//disable keyboard


@end
