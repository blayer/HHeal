//
//  SettingTableViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 9/7/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *notification;
@property (weak, nonatomic) IBOutlet UISwitch *location;
@property (weak, nonatomic) IBOutlet UISwitch *login;
- (IBAction)logout:(id)sender;

- (IBAction)NotificationSwitch:(id)sender;
- (IBAction)LoginSwitch:(id)sender;
- (IBAction)LocationSwitch:(id)sender;


@end
