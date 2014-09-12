//
//  RiskHistoryTableViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 9/10/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "RiskHistoryTableViewController.h"
#import "LineChartViewController.h"

@interface RiskHistoryTableViewController ()
@property int days;
@end

@implementation RiskHistoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.days=30; //default retrieve days
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if(indexPath.row==0)
    {
        self.days=30;
    }
    else if(indexPath.row==1)
    {
        self.days=90;
    }
    
    else if(indexPath.row==2)
    {
        self.days=180;

    }
    
    else if(indexPath.row==3)
    {
        self.days=360;

    }
    else if(indexPath.row==4)
    {
        self.days=720;
    }
    [self performSegueWithIdentifier: @"ShowLineChart" sender: self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{  
    if ([segue.identifier isEqualToString:@"ShowLineChart"]) {
      LineChartViewController  *destViewController = segue.destinationViewController;
        destViewController.retriveDays=self.days;
        
    }
    
}

@end
