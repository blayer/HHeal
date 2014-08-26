//
//  TrainingLogViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 8/11/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingLogViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray *topItems;
@property NSMutableArray *subItems;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
