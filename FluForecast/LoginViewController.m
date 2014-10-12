//
//  LoginViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/29/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//
// In this function, I store user data in the NSUserDefault class.
// The data format of UserDefault is as follow.
//                    key:context
//            @"username":user's account
//            @"password": user's password
//                 @"_id": user's id or token
//           @"autologin": flag to set autologin
//                          more...
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "HHealParameter.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ActivityHub.h"

@interface LoginViewController ()
@property UIAlertView *alertWrongPassword;
@property UIAlertView *alertBlankText;
@property NSDictionary *recievedData;
@property ActivityHub *loadingView;

@end

@implementation LoginViewController

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {
}

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
    
    self.loadingView=[[ActivityHub alloc]initWithFrame:CGRectMake(75, 155, 170, 170)];
    [self.loadingView setLabelText:@"Signing In..."];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email"]];
    
    if (iOSDeviceScreenSize.height == 480)
    {
        CGRect frame=CGRectMake(36.0, 380.0, 256.0, 42.0);
        loginView.frame=frame;

       
    }
    
    if (iOSDeviceScreenSize.height == 568)
    {
        CGRect frame=CGRectMake(36.0, 420.0, 256.0, 42.0);
        loginView.frame=frame;


    }
    
    loginView.delegate = self;
    self.usernameTF.delegate=self;
    self.passwordTF.delegate=self;

    [self.view addSubview:loginView];
    
    
    // adding activity Indicator
    //check if autologin, if yes, login automatically
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL autolog =[defaults boolForKey:@"autologin"];
    
    if(autolog)
    {
        
        [self.loadingView showActivityView];
        [self.view addSubview:self.loadingView];
        NSString *token=[defaults objectForKey:@"token"];
        NSDictionary *query= @{@"token":token};
        
        NSDictionary *parameters=@{@"query":query};
        NSString *url=HHealURL @"/login";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
            NSLog(@"JSON: %@", responseObject);
           
            self.recievedData=responseObject;
         //delay for two seconds
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.loadingView dismissActivityView];
                [self.loadingView removeFromSuperview];
                [self performSegueWithIdentifier: @"LoginSuccess" sender: self];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [self.loadingView dismissActivityView];
            [self.loadingView removeFromSuperview];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
        
            [errorAlert show];
        }];
    
    }
 ///////////////////////////////////////////////////////////////////////////////////////
  self.alertWrongPassword=[[UIAlertView alloc] initWithTitle:@"Login Failed"
                      message:@"Incorrect user name or incorrect password"
                     delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
  self.alertBlankText=[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                       message:@"Please type in your username and password"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
  //  [self.alertBlankText show];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.passwordTF resignFirstResponder];
}


#pragma mark - Navigation



- (IBAction)SignIn:(id)sender {
    [self sendSignIn];
 }


-(void) sendSignIn {
    //clean textfield

    
    [self.loadingView showActivityView];
    [self.view addSubview:self.loadingView];
    
    if(self.passwordTF.text.length>0&&self.usernameTF.text.length>0)
    {
        NSDictionary *query= @{@"username":self.usernameTF.text,
                               @"password":self.passwordTF.text};
        NSDictionary *parameters=@{@"query":query};
        NSString *url=HHealURL @"/login";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
            
            
            
            NSLog(@"JSON: %@", responseObject);
            self.recievedData=responseObject;
            NSString *error =[responseObject objectForKey:@"error"];
            
            if (error.length!=0){
                UIAlertView *LoginAlert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                                     message:error
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                
                [LoginAlert show];
                [self.loadingView dismissActivityView];
                [self.loadingView removeFromSuperview];
                
            }
            // store some data into userdefault
            
            else{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:self.usernameTF.text forKey:@"username"];
                [defaults setObject:self.passwordTF.text forKey:@"password"];
                [defaults setObject:[self.recievedData valueForKey:@"token"] forKey:@"token"];
                [defaults setBool:YES forKey:@"autologin"];
                [defaults synchronize];
                // delay 2 seconds at login
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    self.usernameTF.text=@"";
                    self.passwordTF.text=@"";
                    
                    [self.loadingView dismissActivityView];
                    [self.loadingView removeFromSuperview];
                    [self performSegueWithIdentifier: @"LoginSuccess" sender: self];
                });
             
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            
            [errorAlert show];
            
            [self.loadingView dismissActivityView];
            [self.loadingView removeFromSuperview];
            
        }];
        
    }
    
    else {
        [self.alertBlankText show];
        [self.loadingView dismissActivityView];
        [self.loadingView removeFromSuperview];
            }
    

}



- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [self.loadingView showActivityView];
    [self.view addSubview:self.loadingView];
 
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.loadingView dismissActivityView];
        [self.loadingView removeFromSuperview];
        NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if([token length]==0)
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Your information was not recorded."
                                                                 message:@"Please register an account first. If you have an account, please sign in once."
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            
            [errorAlert show];
            
            [FBSession.activeSession closeAndClearTokenInformation];
        }
        else
        {[self performSegueWithIdentifier: @"LoginSuccess" sender: self];}
    });
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendSignIn];
    return YES;
}



@end
