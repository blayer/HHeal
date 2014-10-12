//
//  SettingTableViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 9/7/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "SettingTableViewController.h"
#import "RootViewController.h"
#import "ActionSheetStringPicker.h"
#import <FacebookSDK/FacebookSDK.h>


@interface SettingTableViewController ()
@property NSDictionary *clock;
@property NSDictionary *hours;

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
    self.clock=@{@"1":@"1:00 am",@"2":@"2:00 am",@"3":@"3:00 am",@"4":@"4:00 am",@"5":@"5:00 am",@"6":@"6:00 am",@"7":@"7:00 am",@"8":@"8:00 am",@"9":@"9:00 am",@"10":@"10:00 am",@"11":@"11:00 am",@"12":@"12:00 am",@"13":@"1:00 pm",@"14":@"2:00 pm",@"15":@"3:00 pm",@"16":@"4:00 pm",@"17":@"5:00 pm",@"18":@"6:00 pm",@"19":@"7:00 pm",@"20":@"8:00 pm",@"21":@"9:00 pm",@"22":@"10:00 pm",@"23":@"11:00 pm",@"24":@"12:00 pm",};
    self.hours=@{@"1":@"1 hour",@"2":@"2 hours",@"3":@"3 hours",@"4":@"4 hours",@"5":@"5 hours",@"6":@"6 hours",@"7":@"7 hours",@"8":@"8 hours",@"9":@"9 hours",@"10":@"10 hours",@"11":@"11 hours",@"12":@"12 hours"};
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL autolog=[defaults boolForKey:@"autologin"];
    int interval=[defaults integerForKey:@"interval"];
    NSString *intervalString = [NSString stringWithFormat:@"%i",interval];
    int daily=[defaults integerForKey:@"daily"];
    NSString *dailyString = [NSString stringWithFormat:@"%i",daily];
    [self.daily setTitle:[self.clock objectForKey:dailyString] forState:UIControlStateNormal];
    [self.reminder setTitle:[self.hours objectForKey:intervalString] forState:UIControlStateNormal];

    [self.login setOn:autolog animated:YES];
    
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


- (IBAction)logout:(id)sender {
    
    UIAlertView *logout=[[UIAlertView alloc]initWithTitle:@"Logout Confirmation"
                                                                    message:@"Are you sure you want to logout? "
                                                                   delegate:self
                                                          cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logout show];
}



- (IBAction)LoginSwitch:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if(self.login.isOn)
    {
        [defaults setBool:YES forKey:@"autologin"];}
    
    else
    {
        [defaults setBool:NO forKey:@"autologin"];
    }
    
    BOOL autolog=[defaults boolForKey:@"autologin"];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
     FBSession* session = [FBSession activeSession];
    
    if([title isEqualToString:@"Yes"])
    {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [self performSegueWithIdentifier: @"LogoutSegue" sender: self];
         [FBSession.activeSession closeAndClearTokenInformation];
    }
    
}



- (IBAction)selectdaily:(id)sender {
    
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.daily setTitle:selectedValue forState:UIControlStateNormal];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:selectedIndex+1 forKey:@"daily"];

    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *time = @[@"1:00 am",@"2:00 am",@"3:00 am",@"4:00 am",@"5:00 am",@"6:00 am",@"7:00 am",@"8:00 am",@"9:00 am",@"10:00 am",@"11:00 am",@"12:00 am",@"1:00 pm",@"2:00 pm",@"3:00 pm",@"4:00 pm",@"5:00 pm",@"6:00 pm",@"7:00 pm",@"8:00 pm",@"9:00 pm",@"10:00 pm",@"11:00 pm",@"12:00 pm"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select your daily notification time" rows:time initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];

    
}

- (IBAction)selectreminder:(id)sender {
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.reminder setTitle:selectedValue forState:UIControlStateNormal];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:selectedIndex+1 forKey:@"interval"];
        
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *time = @[@"1 hour",@"2 hours",@"3 hours",@"4 hours",@"5 hours",@"6 hours",@"7 hours",@"8 hours",@"9 hours",@"10 hours",@"11 hours",@"12 hours",];
    [ActionSheetStringPicker showPickerWithTitle:@"Select your reminder notification interval" rows:time initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];

    
}
@end
