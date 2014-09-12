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
    
    //
    // Here send query to server and get users data like name
    self.userName.text=@"Linazhao128";
    self.streakDays.text=@"15 days";
    self.finishedCards.text=@"3 cards";
    
    self.photo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 60.0, 60.0)];
    [self.photo.layer setBorderColor:[[UIColor whiteColor] CGColor] ];
    [self.photo.layer setBorderWidth:2.0f];
    

   self.photo.image=[UIImage imageNamed:@"Na Li.jpeg"];
    [self.view addSubview:self.photo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
