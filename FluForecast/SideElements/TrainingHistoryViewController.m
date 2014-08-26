//
//  TrainingHistoryViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/23/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "TrainingHistoryViewController.h"
#import "SVPullToRefresh.h"

@interface TrainingHistoryViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TrainingHistoryViewController


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
    // Do any additional setup after loading the view.
    NSDictionary *data1 =@{@"title":@"eat vitamin",@"progress":@"completed",@"date":@"today"};
    NSDictionary *data2= @{@"title":@"drink water",@"progress":@"selected",@"date":@"today"};
    // setup infinite scrolling
    self.dataSource = [NSMutableArray array];
    for(int i=0; i<5; i++)
    {
        [self.dataSource addObject:data1];
        [self.dataSource addObject:data2];
    }
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self insertRowAtBottom];
    }];
}

-(void) addmoredata
{
    
    
    NSDictionary *data1 =@{@"title":@"eat vitamin",@"progress":@"completed",@"date":@"today"};
    NSDictionary *data2= @{@"title":@"drink water",@"progress":@"selected",@"date":@"today"};
    for(int i=0; i<3; i++)
    {
        [self.dataSource addObject:data1];
        [self.dataSource addObject:data2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertRowAtBottom {
    
    int64_t delayInSeconds =1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSMutableArray *indexPaths = [NSMutableArray array];

        for (int i = 0; i < 6; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.dataSource.count+i inSection:0]];
        }
       [self addmoredata];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
       
        [self.tableView endUpdates];
        
        [self.tableView.infiniteScrollingView stopAnimating];
    });
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    NSDictionary *dict = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.detailTextLabel.text =[dict objectForKey:@"date"];
    if([[dict objectForKey:@"progress"] isEqualToString:@"completed"])
    { cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"medal-26.png"]];
    [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];}
    if([[dict objectForKey:@"progress"] isEqualToString:@"selected"])
    {cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkmarkgreen-25.png"]];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];}
    return cell;
}


@end
