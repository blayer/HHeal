//
//  SettingTableViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 9/7/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

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
    return 4;
}


- (IBAction)logout:(id)sender {
    
    UIAlertView *logout=[[UIAlertView alloc]initWithTitle:@"Logout Confirmation"
                                                                    message:@"Are you sure you want to logout? "
                                                                   delegate:self
                                                          cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logout show];
}

- (IBAction)NotificationSwitch:(id)sender {
}

- (IBAction)LoginSwitch:(id)sender {
}

- (IBAction)LocationSwitch:(id)sender {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [self performSegueWithIdentifier: @"LogoutSegue" sender: self];

    }
    
}



@end
