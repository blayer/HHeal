//
//  LoginViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/29/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property UIAlertView *alertWrongPassword;
@property UIAlertView *alertBlankText;
@property NSData *receivedData;
@property NSDictionary *dict;
@end

@implementation LoginViewController

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {}



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
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    
    
    
    
   
    
    
    
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



-(BOOL)loginWithUsername:(NSString *)username Password:(NSString *)password {

    
    
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/user_profile/53f1439d3b240c55ba4bb2a7"];
    //
    // NSURL *url = [NSURL URLWithString:@"http://where?/user_profile/1232324?username=nali&pass="];
    //This shows another example of request with quaries.
    //
    //
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    return true;
}



-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"Server responded");
    
    self.receivedData = [NSMutableData dataWithCapacity:5000];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Receiving data");
    
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection finish loading");
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithStream:self.receivedData options:NSJSONReadingAllowFragments error:nil];
    
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed：%@",[error localizedDescription]);
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (IBAction)SignIn:(id)sender {
    if(self.passwordTF.text.length>0&&self.usernameTF.text.length>0)
    {
        if ([self loginWithUsername:self.usernameTF.text Password:self.passwordTF.text])
        {
           
        
        }
        
        else {
            
            [self.alertWrongPassword show];
        
        }
    
    }
    
    else {
        [self.alertBlankText show];
    }
    
}
@end
