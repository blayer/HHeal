//
//  EbolaRiskViewController.m
//  HHeal
//
//  Created by Changkun Zhao on 10/12/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "EbolaRiskViewController.h"
#import "PNChart.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

#define AveragePerson (float(1000.f))

@interface EbolaRiskViewController ()
@property NSNumber *averageScore;
@property NSNumber *personalScore;
@property NSNumber *average;
@property float nationalFluRate;
@property float personalFluRate;

@end

@implementation EbolaRiskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.averageScore=[NSNumber numberWithFloat:100.0f];
  //  self.personalScore=[NSNumber numberWithFloat:10.0f];
    [self buildView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) buildView
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
activityIndicator.center = self.view.center;
[self.view addSubview: activityIndicator];

[activityIndicator startAnimating];

      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      self.nationalFluRate = [[defaults valueForKey:@"standardrate"] floatValue];
      self.personalFluRate = [[defaults valueForKey:@"personalrate"] floatValue];
      self.personalScore=[NSNumber numberWithFloat:(100.0f)*(sqrt(self.nationalFluRate/self.personalFluRate))];
      NSString *state=[defaults objectForKey:@"state"];
      NSMutableString *url=[NSMutableString new];
      [url appendString:HHealURL];
      [url appendString:Ebola];
      NSDictionary *parameter=@{@"state":state};
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
[manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [activityIndicator stopAnimating];
    NSLog(@"JSON: %@", responseObject);
   
    
    [self.regionalCase setText:[[responseObject valueForKey:@"rate1"]stringValue]];
    [self.nationalCase setText:[[responseObject valueForKey:@"rate2"]stringValue]];
    [self.view setNeedsDisplay];
    [self buildBarChart];
    
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
}


-(void)buildBarChart
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
   
    
    
    UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 60)];
    barChartLabel.text = dateString;
    barChartLabel.textColor = PNFreshGreen;
    barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    barChartLabel.textAlignment = NSTextAlignmentCenter;
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480)
    {     self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 120.0, SCREEN_WIDTH, 210)]; }
    
    if (iOSDeviceScreenSize.height == 568)
    {  self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 120.0, SCREEN_WIDTH, 250)];
    }
    
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    self.barChart.labelMarginTop = 5.0;
    [self.barChart setXLabels:@[@"Average person's score",@"Your score"]];
    
    
    
    // two FluRates are given here
    [self.barChart setYValues:@[self.averageScore,self.personalScore]];
    [self.barChart setStrokeColors:@[PNLightOrange,PNGrassGreen]];
    [self.barChart strokeChart];
    
    self.barChart.delegate = self;
    [self.view addSubview:barChartLabel];
    [self.view addSubview:self.barChart];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
