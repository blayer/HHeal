//
//  TrainingHistoryViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 8/23/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingHistoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
