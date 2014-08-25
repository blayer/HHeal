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
@property NSDictionary *dict;
@property NSString *myid;


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
    
   // Http reads in user profile
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_profile/"];
    if(self.myid!=nil)
    {[url appendString:self.myid];}
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        self.dict=responseObject;
      //  self.fluReported=NO;
        
        if(self.fluReported)
        {self.reportButton.enabled=NO;}
        
        [self.view setNeedsDisplay];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data, Please check your connection."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Error: %@", error);
    }];


    
    self.reportAlert=[[UIAlertView alloc]initWithTitle:@"Report Confirmation"
                                               message:@"Are you sure you want to confirm you flu symtom report? This report will change your risk score significantly"
                                              delegate:self
                                     cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)reportButtonClicked:(id)sender {
    [self.reportAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
     //post geolocation here
        NSDictionary *parameters = @{};
        
        NSString *url=HHealURL @"/flureport";
        NSLog(@"JSON: %@", parameters);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
