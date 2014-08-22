//
//  LoginViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/29/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "HHealParameter.h"


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
     /*    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.usernameTF.text forKey:@"username"];
            [defaults setObject:self.passwordTF.text forKey:@"password"];
            [defaults setObject:[self.recievedData valueForKey:@"_id"] forKey:@"userid"];
            [defaults setBool:YES forKey:@"autologin"];
          
            [defaults synchronize];
        */
            [self performSegueWithIdentifier: @"LoginSuccess" sender: self];
            
            
            
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
@end
