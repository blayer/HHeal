//
//  BarChartViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/25/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "BarChartViewController.h"
#import "PNChart.h"
#import "AFNetworking.h"
#import "HHealParameter.h"
#import <CoreLocation/CoreLocation.h>
#import "ActivityHub.h"


@interface BarChartViewController ()
@property NSNumber *nationalFluRate;
@property NSNumber *personalFluRate;
@property NSString *trainingCards;
@property NSData *receivedData;
@property NSDictionary *dict;
@property NSArray *myCards;
@property NSString *myid;
@property ActivityHub *reportView;
@property ActivityHub *completeView;
@end

@implementation BarChartViewController

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
 //   [self buildView];
    self.reportView=[[ActivityHub alloc]initWithFrame:CGRectMake(75, 155, 170, 170)];
    [self.reportView setLabelText:@"Reporting current location..."];
    [self.reportView setImage:[UIImage imageNamed:@"geo_fence-50.png"]];
    
    self.completeView=[[ActivityHub alloc]initWithFrame:CGRectMake(75, 155, 170, 170)];
    [self.completeView setLabelText:@"Reporting Completed"];
    [self.completeView setImage:[UIImage imageNamed:@"checked_checkbox-48.png"]];
}


-(void) viewWillAppear:(BOOL)animated
{   [self buildView];
    [self.view setNeedsDisplay];

}


-(void) buildView
{
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
        
        self.dict=responseObject;
        [defaults setObject:[self.dict objectForKey:@"agegroup"] forKey:@"agegroup"];
        [defaults setObject:[self.dict objectForKey:@"username"] forKey:@"username"];
        [defaults setObject:[self.dict objectForKey:@"gender"] forKey:@"gender"];
        [defaults setObject:[self.dict objectForKey:@"state"] forKey:@"state"];
        [defaults setObject:[self.dict objectForKey:@"email"] forKey:@"email"];
        [defaults setObject:[self.dict objectForKey:@"personalrate"] forKey:@"personalrate"];
        [defaults setObject:[self.dict objectForKey:@"standardrate"] forKey:@"standardrate"];
        
        self.nationalFluRate = [NSNumber numberWithFloat:([[self.dict valueForKey:@"standardrate"] floatValue])];
        self.personalFluRate = [NSNumber numberWithFloat:([[self.dict valueForKey:@"personalrate"] floatValue])];
        
        [self buildBarChart];
        
        [self.view setNeedsDisplay];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildBarChart
{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 30)];
    barChartLabel.text = dateString;
    barChartLabel.textColor = PNFreshGreen;
    barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    barChartLabel.textAlignment = NSTextAlignmentCenter;
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 240.0)];
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    self.barChart.labelMarginTop = 5.0;
    [self.barChart setXLabels:@[@"CDC local risk(%)",@"Your risk(%)"]];
    
    
    
    // two FluRates are given here
    [self.barChart setYValues:@[self.nationalFluRate,self.personalFluRate]];
    [self.barChart setStrokeColors:@[PNBlue,PNGreen]];
    [self.barChart strokeChart];
    
    self.barChart.delegate = self;
    [self.view addSubview:barChartLabel];
    [self.view addSubview:self.barChart];
}


-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

- (void)userClickedOnBarCharIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));

    
 //  PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
 // [bar.layer addAnimation:animation forKey:@"Float"];
}

- (IBAction)sendLocation:(id)sender {

    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasReportOnce"])
    {   NSDate *date=[NSDate dateWithTimeIntervalSince1970:100];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasReportOnce"];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"lastreportdate"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks for your first location report."
                                                            message:@"Frequently reporting your current location can help us to identify your location and potential flu risks around you.To get a better flu risk estimation, please report your location when you are at a new public place."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alert show];
    }
    else
    {
    if([self isTimeUp])
    
    {
        [self.reportView showActivityView];
    [self.view addSubview:self.reportView];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =[defaults valueForKey:@"token"];
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_location/"];
    if(token!=nil)
    {[url appendString:token];}
    CLLocation *location =[locationManager location];
    
    NSString *lat =[NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *lng =[NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSDictionary *parameters=@{@"lng":lng,@"lat":lat};
    
    NSLog(@"Coordinate: %@", parameters);

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
   
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDate *date=[NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"lastreportdate"];
        
        [self.reportView dismissActivityView];
        [self.reportView removeFromSuperview];
        [self.view addSubview:self.completeView];
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.completeView removeFromSuperview];
        });

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.reportView dismissActivityView];
        [self.reportView removeFromSuperview];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Report Error!"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
        
        [errorAlert show];

        
    }];
    
    });}
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reporting location too often"
                                                            message:@"Reporting location too often can decrease the accuracy of your flu risk.We only allow to report location at most every 5 mins."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];}
    }
}

-(BOOL) isTimeUp {
    
    NSDate *currentdate=[NSDate date];
    NSDate *lastdate=[[NSUserDefaults standardUserDefaults] objectForKey:@"lastreportdate"];
    NSTimeInterval intervel=[currentdate timeIntervalSinceDate:lastdate];
    if(intervel>300)
     return YES;
    else
    return NO;
}
@end
