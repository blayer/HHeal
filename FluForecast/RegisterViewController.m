//
//  RegisterViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/28/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "HHealParameter.h"
#import "ActionSheetStringPicker.h"




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
 //   [self.Age setDelegate:self];
 //   [self.Gender setDelegate:self];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
    
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
   // [self.UserName resignFirstResponder];
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



- (IBAction)SelectAge:(id)sender {
    
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = @[@"0~18", @"18~25",@"23~35",@"35~60",@"60 and up"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your Age" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)SelectGender:(id)sender {
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = @[@"Male", @"Female"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your Gender" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
    
}

- (IBAction)SelectState:(id)sender {
    
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *states = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District of Columbia", @"Florida", @"Georgia", @"Guam", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Puerto Rico", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Virgin Islands", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your State" rows:states initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)RegisterProfile:(id)sender {

    if(![self isBlankText]&&[self isCorrectAge]&&[self isPasswordLongEnough]&&[self isPasswordMatch])
    {   
        NSNumber *ageGroup=[[NSNumber alloc]init];
        if ([self.Age.text isEqualToString:@"0~18"])
            ageGroup=@1;
        else if ([self.Age.text isEqualToString:@"18~25"])
            ageGroup=@2;
        else if ([self.Age.text isEqualToString:@"25~35"])
            ageGroup=@3;
        else if([self.Age.text isEqualToString:@"35~60"])
            ageGroup=@4;
        else if([self.Age.text isEqualToString:@"60 and up"])
            ageGroup=@5;
        
        NSDate *date= [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        NSDictionary *parameters = @{@"username":self.UserName.text,@"password":self.Password.text,@"agegroup":ageGroup,@"state":self.State.text,@"date":dateString};
        
        NSString *url=HHealURL @"/user_profile";
        
        NSLog(@"JSON: %@", parameters);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //by default, AF manager uses HTTP request, we have to change it to JSON request when we want to post a JSON
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSString *errorMessage=[responseObject valueForKey:@"error"];
            
            if(!(errorMessage==nil))
            {
                UIAlertView *exitAlert = [[UIAlertView alloc] initWithTitle:@"Registration Error!"
                                                                     message:errorMessage
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                
                [ exitAlert show];
                
            }
            
           else
           {
            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Registration Succeed!"
                                                                message:@"Please return to login page"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [successAlert show];
               
               NSString *token=[responseObject objectForKey:@"token"];
            //after successful registration, go back to the Login page automatically
               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               [defaults setObject:token forKey:@"token"];
               
               [self performSegueWithIdentifier: @"BacktoLogin" sender: self];}

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Registration Error!"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [ errorAlert show];

            
        }];
    
    }
    
    else [self showAlertMessage];
}


//disable keyboard


@end
