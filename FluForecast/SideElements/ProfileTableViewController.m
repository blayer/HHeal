//
//  ProfileTableViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 9/7/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ActionSheetStringPicker.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController



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
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.gender.titleLabel.text=[defaults objectForKey:@"gener"];
    self.state.titleLabel.text=[defaults objectForKey:@"state"];
    self.email.titleLabel.text=[defaults objectForKey:@"email"];
    NSString *ageGroup= [defaults objectForKey:@"agegroup"];
    if ([ageGroup isEqualToString:@"1"])
        self.age.titleLabel.text=@"0~18";
    else if ([ageGroup isEqualToString:@"2"])
        self.age.titleLabel.text=@"18~25";
    else if ([ageGroup isEqualToString:@"3"])
        self.age.titleLabel.text=@"25~35";
    else if ([ageGroup isEqualToString:@"4"])
        self.age.titleLabel.text=@"35~60";
    else if ([ageGroup isEqualToString:@"5"])
        self.age.titleLabel.text=@"60 and up";
    
    [self.state.titleLabel sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidDisappear:(BOOL)animated
{ //sending back changes here, when view disappeared.
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



- (IBAction)SelectGender:(id)sender {

    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.gender setTitle:selectedValue forState:UIControlStateNormal];
        

    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = @[@"Male", @"Female"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your Gender" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
}

- (IBAction)SelectAge:(id)sender {
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.age setTitle:selectedValue forState:UIControlStateNormal];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = @[@"0~18", @"18~25",@"23~35",@"35~60",@"60 and up"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your Age" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)SelectState:(id)sender {
    
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [self.state setTitle:selectedValue forState:UIControlStateNormal];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *states = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District of Columbia", @"Florida", @"Georgia", @"Guam", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Puerto Rico", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Virgin Islands", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Your State" rows:states initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)ChangeEmail:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Please enter your new email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"new email";

    [alert show];
  }


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"])
    {
        [ self.email setTitle:([[alertView textFieldAtIndex:0] text]) forState:UIControlStateNormal];
    }

        }






@end
