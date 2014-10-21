//
//  ProfileTableViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 9/7/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ActionSheetStringPicker.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

@interface ProfileTableViewController ()
@end

@implementation ProfileTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =[defaults valueForKey:@"token"];
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_profile/"];
    if(token!=nil)
    {[url appendString:token];}
    [url appendString:@"/"];
    
    
    NSDictionary *parameter=@{@"date":dateString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activityIndicator stopAnimating];
        NSLog(@"JSON: %@", responseObject);
    
        [self.gender setTitle:[responseObject objectForKey:@"gender"] forState:UIControlStateNormal];
        [self.state setTitle:[responseObject objectForKey:@"state"] forState:UIControlStateNormal];
        [self.email setTitle:[responseObject objectForKey:@"email"] forState:UIControlStateNormal];
        
        
        NSString *ageGroup=[NSString stringWithFormat:@"%@",
                            [responseObject objectForKey:@"agegroup"]];
        
        if ([ageGroup isEqualToString:@"0"])
            [self.age setTitle:@"0~4" forState:UIControlStateNormal];
        else if ([ageGroup isEqualToString:@"1"])
            [self.age setTitle:@"5~24" forState:UIControlStateNormal];
        else if ([ageGroup isEqualToString:@"2"])
            [self.age setTitle:@"25~49" forState:UIControlStateNormal];
        else if ([ageGroup isEqualToString:@"3"])
            [self.age setTitle:@"50~64" forState:UIControlStateNormal];
        else if ([ageGroup isEqualToString:@"4"])
            [self.age setTitle:@"65 and up" forState:UIControlStateNormal];
        
        [self.state.titleLabel sizeToFit];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [activityIndicator stopAnimating];
        [self.view setNeedsDisplay];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data, Please check your connection."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    [self.gender setTitle:[defaults objectForKey:@"gender"] forState:UIControlStateNormal];
    [self.state setTitle:[defaults objectForKey:@"state"] forState:UIControlStateNormal];
    [self.email setTitle:[defaults objectForKey:@"email"] forState:UIControlStateNormal];

    
    NSString *ageGroup=[NSString stringWithFormat:@"%@",
                        [defaults objectForKey:@"agegroup"]];
    
    if ([ageGroup isEqualToString:@"0"])
        [self.age setTitle:@"0~4" forState:UIControlStateNormal];
    else if ([ageGroup isEqualToString:@"1"])
        [self.age setTitle:@"5~24" forState:UIControlStateNormal];
    else if ([ageGroup isEqualToString:@"2"])
        [self.age setTitle:@"25~49" forState:UIControlStateNormal];
    else if ([ageGroup isEqualToString:@"3"])
        [self.age setTitle:@"50~64" forState:UIControlStateNormal];
    else if ([ageGroup isEqualToString:@"4"])
        [self.age setTitle:@"65 and up" forState:UIControlStateNormal];
    
    [self.state.titleLabel sizeToFit];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated
{

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}



- (IBAction)SelectGender:(id)sender {

    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.gender setTitle:selectedValue forState:UIControlStateNormal];
        [self updateProfile:@"gender" contentedofProfile:selectedValue];


    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = @[@"Male", @"Female"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your Gender" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
}

- (IBAction)SelectAge:(id)sender {
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.age setTitle:selectedValue forState:UIControlStateNormal];
        NSString *ageString= [NSString stringWithFormat:@"%d", selectedIndex+1];
        [self updateProfile:@"agegroup" contentedofProfile:ageString];
        NSLog(@"age",selectedValue);
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = @[@"0~4", @"5~24",@"25~49",@"50~64",@"65 and up"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your Age" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)SelectState:(id)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [self.state setTitle:selectedValue forState:UIControlStateNormal];
        [self updateProfile:@"state" contentedofProfile:selectedValue];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *states = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District of Columbia", @"Florida", @"Georgia", @"Guam", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Puerto Rico", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Virgin Islands", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your State" rows:states initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)ChangeEmail:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Please enter your new email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"new email";

    [alert show];
  }


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"])
    {
        [ self.email setTitle:([[alertView textFieldAtIndex:0] text]) forState:UIControlStateNormal];
        [self updateProfile:@"email" contentedofProfile:([[alertView textFieldAtIndex:0] text])];
    }

        }

-(void) updateProfile: (NSString*) profileTitle contentedofProfile:(NSString*)content
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_profile/"];
    if(token!=nil)
    {[url appendString:token];}
    NSDictionary *parameter=@{profileTitle:content};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"profile updated");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile updated."
                                                            message:@"Your profile updates will be reflected on your flu risk in 24 hours."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data, Please check your connection."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Error: %@", error);
    }];
    
    

}
@end
