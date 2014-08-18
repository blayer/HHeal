//
//  BarChartViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/25/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "BarChartViewController.h"
#import "PNChart.h"




@interface BarChartViewController ()
@property NSNumber *nationalFluRate;
@property NSNumber *personalFluRate;
@property NSString *trainingCards;
@property NSData *receivedData;
@property NSDictionary *dict;
@property NSArray *myCards;
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
    
    //pre-load some testing data
    self.myCards= [[NSArray alloc]initWithObjects:@"Drinking water",@"Taking Vatamin D",@"Wash your hands",@"Eat more fruit",nil];
    
    
    
    
     NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
    
 //    NSString *userID= [profile stringForKey:@"myID"];
    
 
    
    // Do any additional setup after loading the view.
    //we need to get national data, personal data, and training cards
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/user_profile/53f1439d3b240c55ba4bb2a7"];
   //
   //NSURL *url = [NSURL URLWithString:@"http://where?/user_profile/1232324?username=nali&pass="];
   //This shows another example of request with quaries. 
   //
   //
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //asynchronize loading
  //  [NSURLConnection connectionWithRequest:request delegate:self];
 
    //synchronized loading
   self.receivedData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   
    NSError* error;
    
    self.dict = [NSJSONSerialization JSONObjectWithData:self.receivedData
                                                options: NSJSONReadingMutableContainers
                                                  error: &error];
    
    self.nationalFluRate = [NSNumber numberWithInt:([[self.dict valueForKey:@"standardrate"] intValue]) ];
    self.personalFluRate = [NSNumber numberWithInt:([[self.dict valueForKey:@"personalrate"] intValue]) ];
    
    
    // building up barchart visualization
    UILabel * barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    barChartLabel.text = @"Monday, August 4.";
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

    
    //Add CircleChart
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    


/*
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"Server responded");
    
    self.receivedData = [[NSMutableData alloc]init];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Receiving data");
    [self.receivedData appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection finish loading");
    
    
//    NSString *receiveStr = [[NSString alloc]initWithData:self.receivedData encoding:NSUTF8StringEncoding];
  //  NSLog(receiveStr);
   
    NSError* error;
    
    self.dict = [NSJSONSerialization JSONObjectWithData:self.receivedData
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    
    
 //  self.dict = [NSJSONSerialization JSONObjectWithStream:receiveStr options:NSJSONReadingAllowFragments error:nil];
    
    
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed：%@",[error localizedDescription]);
}


*/

/*
 
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
