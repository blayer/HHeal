//
//  SettingTableViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 9/7/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *login;
- (IBAction)logout:(id)sender;

- (IBAction)LoginSwitch:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *daily;
@property (weak, nonatomic) IBOutlet UIButton *reminder;
- (IBAction)selectdaily:(id)sender;
- (IBAction)selectreminder:(id)sender;

@end
