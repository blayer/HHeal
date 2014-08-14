//
//  ReportFluViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/14/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ReportFluViewController.h"

@interface ReportFluViewController ()
@property UIAlertView *reportAlert;

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
    
    self.reportAlert=[[UIAlertView alloc]initWithTitle:@"Report Confirmation"
                                               message:@"Are you sure you want to confirm you flu symtom report? This report will change your risk score significantly"
                                              delegate:nil
                                     cancelButtonTitle:@"Yes,I confirm." otherButtonTitles:@"No,Do not confirm", nil];
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
@end
