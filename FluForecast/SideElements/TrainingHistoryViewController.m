//
//  TrainingHistoryViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/23/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "TrainingHistoryViewController.h"
#import "SVPullToRefresh.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

//#define      CellNumberofPage  ((int)2)

@interface TrainingHistoryViewController ()
@property (nonatomic, strong) NSMutableArray *mylogs;
@property int CellNumberofPage;
@property BOOL loadingLock;
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
    __weak TrainingHistoryViewController *weakSelf = self;
    self.loadingLock=YES;
    self.mylogs=[NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingLogs];
    [url appendString:token];
    
    NSDictionary *parameters=@{@"date":dateString};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TrainingLogs: %@", responseObject);
        self.CellNumberofPage=(int)[responseObject count];
        [self.mylogs addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        if([responseObject count]!=0)
        {self.loadingLock=NO;}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if(!(self.loadingLock)){
            [weakSelf loadMoreLogs];}
    }];
}

-(void) loadMoreLogs
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    NSString *lastId=[[self.mylogs objectAtIndex:([self.mylogs count]-1)] objectForKey:@"_id"];
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingLogs];
    [url appendString:token];
    
    NSDictionary *parameters=@{@"_id":lastId};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TrainingLogs: %@", responseObject);
        self.CellNumberofPage=(int)[responseObject count];
        [self.mylogs addObjectsFromArray:responseObject];
        
        [self insertRowAtBottom];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertRowAtBottom {
    
    __weak TrainingHistoryViewController *weakSelf = self;

    int64_t delayInSeconds =1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSMutableArray *indexPaths = [NSMutableArray array];

        for (int i = 0; i < self.CellNumberofPage; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.mylogs.count+i-self.CellNumberofPage inSection:0]];
        }
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mylogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    NSDictionary *dict = [self.mylogs objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.detailTextLabel.text =[dict objectForKey:@"date"];
    if([[dict objectForKey:@"progress"] isEqualToString:@"completed"])
    { cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"ribbon_yellow-48.png"]];
    [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];}
    if([[dict objectForKey:@"progress"] isEqualToString:@"selected"])
    {cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkmarkgreen-25.png"]];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];}
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView triggerPullToRefresh];
}


@end
