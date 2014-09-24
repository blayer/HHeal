//
//  LineChartViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/25/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "LineChartViewController.h"
#import "PNChart.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

#define NumberOfXLabel ((int) 5)

@interface LineChartViewController ()
@property NSString *button;
@property PNLineChart *lineChart;
@property NSArray *riskHistory;
@property NSMutableArray *personalHistory;
@property NSMutableArray *nationalHistory;
@property NSMutableArray *dateHistory;


@end

@implementation LineChartViewController

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
    
    self.personalHistory=[NSMutableArray new];
    self.nationalHistory=[NSMutableArray new];

    self.dateHistory=[NSMutableArray new];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetRiskLogs];
    [url appendString:token];
    
    NSDictionary *parameters=@{@"limit":[NSString stringWithFormat:@"%d",self.retriveDays]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"RiskLogs: %@", responseObject);
        
        self.riskHistory=responseObject;
        
        for(int i=0;i<[self.riskHistory count];i++)
        {
            NSDictionary *log=[self.riskHistory objectAtIndex:i];
            NSString *date=[log objectForKeyedSubscript:@"date"];
            NSString *personal=[log objectForKeyedSubscript:@"personalrate"];
            NSString *national=[log objectForKeyedSubscript:@"standardrate"];
            if(i%(self.retriveDays/NumberOfXLabel)!=0)
            {[self.dateHistory addObject:@""];} //add empty string
            else {[self.dateHistory addObject:date];}
            
            [self.personalHistory addObject:personal];
            [self.nationalHistory addObject:national];
        }
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 190.0, SCREEN_WIDTH, 300.0)];
        
        [self buildLineChart];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) buildLineChart
{
    //Add LineChart
    UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 30)];
    lineChartLabel.text = @"Risk History";
    lineChartLabel.textColor = PNFreshGreen;
    lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    lineChartLabel.textAlignment = NSTextAlignmentCenter;
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:self.dateHistory];
    // lineChart.showCoordinateAxis = YES;
    // Line Chart Nr.1

    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = self.lineChart.xLabels.count;
    //    data01.inflexionPointStyle = PNLineChartPointStyleCycle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [self.nationalHistory[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart Nr.2
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = self.lineChart.xLabels.count;
    //   data02.inflexionPointStyle = PNLineChartPointStyleSquare;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [self.personalHistory[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01, data02];
    [self.lineChart strokeChart];
    
    self.lineChart.delegate = self;
    
   [self.view addSubview:lineChartLabel];
    [self.view addSubview:self.lineChart];
    
    self.title = @"Risk History";


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
