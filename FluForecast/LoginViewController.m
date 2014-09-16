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

@interface LoginViewController ()
@property UIAlertView *alertWrongPassword;
@property UIAlertView *alertBlankText;
@property NSDictionary *recievedData;
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
    
    CGRect frame=CGRectMake(36.0, 420.0, 256.0, 42.0);

    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email"]];
    loginView.frame=frame;
    
    loginView.delegate = self;

    [self.view addSubview:loginView];
    
    
    //check if autologin, if yes, login automatically
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"autologin"])
    {
     /*   NSString *usrname=[defaults objectForKey:@"username"];
        NSString *psw=[defaults objectForKey:@"password"];
        NSDictionary *parameters= @{@"username":usrname,
                                    @"password":psw};
        NSString *url=HHealURL @"/login";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
            NSLog(@"JSON: %@", responseObject);
            self.recievedData=responseObject;
            [self performSegueWithIdentifier: @"LoginSuccess" sender: self];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            [errorAlert show];
        }];
    */
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
    
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    [self.view setNeedsDisplay];
    
    
    if(self.passwordTF.text.length>0&&self.usernameTF.text.length>0)
    {
      
        NSDictionary *parameters= @{@"username":self.usernameTF.text,
                                    @"password":self.passwordTF.text};
        
        NSString *url=HHealURL @"/login";
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
     [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
         
            
            
            NSLog(@"JSON: %@", responseObject);
            self.recievedData=responseObject;
         
         
         
         // store some data into userdefault
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.usernameTF.text forKey:@"username"];
            [defaults setObject:self.passwordTF.text forKey:@"password"];
            [defaults setObject:[self.recievedData valueForKey:@"_id"] forKey:@"userid"];
            [defaults setBool:YES forKey:@"autologin"];
            [defaults synchronize];
         // delay 2 seconds at login
         double delayInSeconds = 2.0;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         [self performSegueWithIdentifier: @"LoginSuccess" sender: self];
         });
         
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            
            [errorAlert show];
            
            [activityIndicator stopAnimating];
            
            [self.view setNeedsDisplay];
            
        }];
        
    }
    
    else {
        [self.alertBlankText show];
        [activityIndicator stopAnimating];
        [self.view setNeedsDisplay];
    }
    
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    
   
    [self performSegueWithIdentifier: @"LoginSuccess" sender: self];
    
    
    

}





@end
