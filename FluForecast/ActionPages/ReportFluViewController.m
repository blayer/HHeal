//
//  ReportFluViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/14/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ReportFluViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HHealParameter.h"
#import "AFNetworking.h"
#import "ActivityHub.h"

@interface ReportFluViewController ()
@property UIAlertView *reportAlert;
@property CLLocationManager *mylocationManager;
@property ActivityHub *reportView;
@property ActivityHub *completeView;

@end

@implementation ReportFluViewController

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
    //start geolocation service
    self.reportView=[[ActivityHub alloc]initWithFrame:CGRectMake(75, 155, 170, 170)];
    [self.reportView setLabelText:@"Reporting Flu..."];
    [self.reportView setImage:[UIImage imageNamed:@"geo_fence-50.png"]];
    
    self.completeView=[[ActivityHub alloc]initWithFrame:CGRectMake(75, 155, 170, 170)];
    [self.completeView setLabelText:@"Reporting Completed"];
    [self.completeView setImage:[UIImage imageNamed:@"checked_checkbox-48.png"]];
    self.mylocationManager = [[CLLocationManager alloc] init];
    [self.mylocationManager requestWhenInUseAuthorization];
    self.mylocationManager.delegate = self;
    self.mylocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.mylocationManager startUpdatingLocation];
    
    self.reportAlert=[[UIAlertView alloc]initWithTitle:@"Report Confirmation"
                                               message:@"Are you sure you want to confirm you flu symtom report? This report will change your risk score significantly"
                                              delegate:self
                                     cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)reportButtonClicked:(id)sender {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        
        UIAlertView *locationAlert = [[UIAlertView alloc] initWithTitle:@"Location service disabled!"
                                                        message:@"Please enable location service in the Settings to report location."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [locationAlert show];

        
    }
    else {
    if  ([self.coughSwitch isOn]||[self.feverSwitch isOn]||[self.sourSwitch isOn])
    { [self.reportAlert show];}
  else {
      UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Report Error!"
                                                           message:@"Please report your flu-like symptoms.If you have none symtoms above, please do not report."
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
      
      [Alert show];
  }}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        [self.reportView showActivityView];
        [self.view addSubview:self.reportView];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token =[defaults valueForKey:@"token"];

        NSMutableString *url=[NSMutableString new];
        [url appendString:HHealURL];
        [url appendString:ReportFlu];
        if(token!=nil)
        {[url appendString:token];}
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            [self.reportView dismissActivityView];
            [self.reportView removeFromSuperview];
            [self.view addSubview:self.completeView];
             double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
                [self.completeView removeFromSuperview];
            });

            
        //    [self performSegueWithIdentifier: @"ReportBacktoMainPage" sender: self];

            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [self.reportView dismissActivityView];
            [self.reportView removeFromSuperview];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Report Error!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            
            [ errorAlert show];
            
        }];
            
        });
        
    }
    
}


@end
