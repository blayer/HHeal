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




@interface BarChartViewController ()
@property NSNumber *nationalFluRate;
@property NSNumber *personalFluRate;
@property NSString *trainingCards;
@property NSData *receivedData;
@property NSDictionary *dict;
@property NSArray *myCards;
@property NSString *myid;
@end

@implementation BarChartViewController

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

     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.myid=[defaults objectForKey:@"_id"];
    //pre-load some testing data
    self.myCards= [[NSArray alloc]initWithObjects:@"Drinking water",@"Taking Vatamin D",@"Wash your hands",@"Eat more fruit",nil];
    
    
    
    
    
 //    NSString *userID= [profile stringForKey:@"myID"];
    
 
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_profile/"];
    if(self.myid!=nil)
    {[url appendString:self.myid];}
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"JSON: %@", responseObject);
    
        self.dict=responseObject;
        self.nationalFluRate = [NSNumber numberWithInt:([[self.dict valueForKey:@"standardrate"] intValue]) ];
        self.personalFluRate = [NSNumber numberWithInt:([[self.dict valueForKey:@"personalrate"] intValue]) ];
        
        [self buildBarChart];
        
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
    
    
    
    
    
    // building up barchart visualization
 

    
    //Add CircleChart
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
    
    UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    barChartLabel.text = dateString;
    barChartLabel.textColor = PNFreshGreen;
    barChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    barChartLabel.textAlignment = NSTextAlignmentCenter;
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 50.0, SCREEN_WIDTH, 240.0)];
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    self.barChart.labelMarginTop = 5.0;
    [self.barChart setXLabels:@[@"National",@"Personal"]];
    
    
    
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
    
    animation.fromValue= @1.0;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.toValue= @1.1; 
    
    animation.duration= 0.2;
    
    animation.repeatCount = 0;
    
    animation.autoreverses = YES;
    
    animation.removedOnCompletion = YES;
    
    animation.fillMode=kCAFillModeForwards;
    
 // [bar.layer addAnimation:animation forKey:@"Float"];
}

@end
