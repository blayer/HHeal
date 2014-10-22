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

#define DifferenceOfLines ((float) 0.05)

@interface LineChartViewController ()
@property NSString *button;
@property PNLineChart *lineChart;
@property (nonatomic,strong)NSArray *riskHistory;
@property (nonatomic,strong)NSMutableArray *personalHistory;
@property (nonatomic,strong)NSMutableArray *nationalHistory;
@property (nonatomic,strong)NSMutableArray *dateHistory;


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
    
    self.personalHistory=[NSMutableArray array];
    self.nationalHistory=[NSMutableArray array];

    self.dateHistory=[NSMutableArray array];

    
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
        NSInteger length=[responseObject count];
        if(length==0)
        {[self.view setUserInteractionEnabled:NO];}
        [self setXLabels];
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

-(void)setXLabels{
    int count=1;
    for(int i=0;i<[self.riskHistory count];i++)
    {
      NSDictionary  *log=[self.riskHistory objectAtIndex:i];
        NSString *fulldate=[log objectForKeyedSubscript:@"date"];
        NSArray *substring=[fulldate componentsSeparatedByString:@","];
        NSString *date=[substring objectAtIndex:1];
        NSString *personal=[log objectForKeyedSubscript:@"personalrate"];
        NSString *national=[log objectForKeyedSubscript:@"standardrate"];
        NSNumber *nationalFluRate = [NSNumber numberWithFloat:([national floatValue])*100-DifferenceOfLines ];
        NSNumber *personalFluRate = [NSNumber numberWithFloat:([personal floatValue])*100 ] ;
        
        if (self.retriveDays==7){
            NSArray *subdate=[date componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *day= [subdate objectAtIndex:2]; //why at the third objects?
            [self.dateHistory addObject:day];
        }
        
        if (self.retriveDays==30)
        {
            if(i%7!=0)
            {[self.dateHistory addObject:@""];}
            else
            { NSString *week=[NSString stringWithFormat:@"week %d",count];
                [self.dateHistory addObject:week];
                count++;}
         
        }
        if (self.retriveDays==90)
        {  NSArray *subdate=[date componentsSeparatedByString:@" "];
            NSString *month=[subdate objectAtIndex:0];
            int day= [[subdate objectAtIndex:1] intValue];
            if(day==1)
            {[self.dateHistory addObject:month];}
            else
            {[self.dateHistory addObject:@""];}
            
        }
        
        if (self.retriveDays==360)
        {
            NSArray *subdate=[date componentsSeparatedByString:@" "];
            NSString *month=[subdate objectAtIndex:0];
            int day= [[subdate objectAtIndex:1] intValue];
            if(day==1)
            {[self.dateHistory addObject:month];}
            else
            {[self.dateHistory addObject:@""];}
        }
            [self.nationalHistory addObject:nationalFluRate];
            [self.personalHistory addObject:personalFluRate];
    }
    
}

-(void) buildLineChart
{
    //Add LineChart
    UILabel * lineChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 30)];
    lineChartLabel.text = @"Risk History";
    lineChartLabel.textColor = PNBlack;
    lineChartLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:23.0];
    lineChartLabel.textAlignment = NSTextAlignmentCenter;
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:self.dateHistory];
    // lineChart.showCoordinateAxis = YES;
    // Line Chart Nr.1

    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNBlue;
    data01.itemCount = self.lineChart.xLabels.count;
    //    data01.inflexionPointStyle = PNLineChartPointStyleCycle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [self.nationalHistory[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart Nr.2
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNGreen;
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




@end
