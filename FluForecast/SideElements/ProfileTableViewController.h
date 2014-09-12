//
//  ProfileTableViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 9/7/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UITableViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIButton *gender;
@property (weak, nonatomic) IBOutlet UIButton *age;
@property (weak, nonatomic) IBOutlet UIButton *state;
@property (weak, nonatomic) IBOutlet UIButton *email;

- (IBAction)SelectGender:(id)sender;
- (IBAction)SelectAge:(id)sender;
- (IBAction)SelectState:(id)sender;
- (IBAction)ChangeEmail:(id)sender;


@end
