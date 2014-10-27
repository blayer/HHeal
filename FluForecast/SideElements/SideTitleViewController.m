//
//  SideTitleViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 9/5/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "SideTitleViewController.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

@interface SideTitleViewController ()

@property UIImageView *photo;
@property NSArray *myCards;
@property NSString *selected;
@property NSString *completed;

@end

@implementation SideTitleViewController

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
    [self buildView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
}
-(void) buildView
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_trainingcard/"];
    [url appendString:token];
    [url appendString:@"/"];
    [url appendString:dateString];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ScrollView JSON: %@", responseObject);
        
        self.myCards=responseObject;
        
        self.selected=[NSString stringWithFormat:@"%li",  [self.myCards count]];
        [[NSUserDefaults standardUserDefaults] setInteger:[self.myCards count] forKey:@"numberofselected"];
        
        self.completed=[NSString stringWithFormat:@"%d",[self countCompletedCardsNumber]];
        [[NSUserDefaults standardUserDefaults] setInteger:[self countCompletedCardsNumber]forKey:@"numberofcompleted"];
        
        [self buildSideTitle];
        [self.view setNeedsDisplay];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void) buildSideTitle
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *title=[defaults objectForKey:@"username"];
    // Here send query to server and get users data like name
    self.userName.text=title;
    self.streakDays.text=@"15 days";
    self.finishedCards.text=[NSString stringWithFormat:@"%@/%@ cards",self.completed,self.selected];
    
  //  self.photo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 60.0, 60.0)];
  //  [self.photo.layer setBorderColor:[[UIColor whiteColor] CGColor] ];
  //  [self.photo.layer setBorderWidth:2.0f];
  //  [self.photo.layer setBackgroundColor:[[UIColor whiteColor] CGColor] ];
    
    //   [self.photo setBackgroundColor:uic]
    
    
  //  self.photo.image=[UIImage imageNamed:@"user-48.png"];
  //  [self.view addSubview:self.photo];

}

-(int) countCompletedCardsNumber
{
    int count=0;
    for(int i=0;i<[self.myCards count];i++){
        
        if([[[self.myCards objectAtIndex:i] objectForKey:@"progress"] isEqualToString:@"completed"])
        {
            count++;
        }
        
    }
    
    
    return count;
}

@end
