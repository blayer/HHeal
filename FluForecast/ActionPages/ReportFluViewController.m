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


@interface ReportFluViewController ()
@property UIAlertView *reportAlert;
@property CLLocationManager *mylocationManager;

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
    self.mylocationManager = [[CLLocationManager alloc] init];
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
    [self.reportAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
           
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token =[defaults valueForKey:@"token"];

        NSMutableString *url=[NSMutableString new];
        [url appendString:HHealURL];
        [url appendString:ReportFlu];
        if(token!=nil)
        {[url appendString:token];}
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Report Succeed!"
                                                                   message:@"Please return to login page"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
            [successAlert show];
            
            [self performSegueWithIdentifier: @"ReportBacktoMainPage" sender: self];

            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Report Error!"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            
            [ errorAlert show];
            
        }];
        
    }
    
}


@end
