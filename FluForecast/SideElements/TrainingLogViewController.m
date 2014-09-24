//
//  TrainingLogViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/11/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "TrainingLogViewController.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

@interface TrainingLogViewController ()
@property (nonatomic) int currentExpandedIndex;
@property NSString *title;

@end

@implementation TrainingLogViewController
@synthesize myTableView;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self setTitle:@"Hello title"];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingLogs];
    [url appendString:token];

    NSDictionary *parameters=@{@"date":dateString};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ScrollView JSON: %@", responseObject);
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    [ self.myTableView setTintColor:[UIColor greenColor]]; //change tint color including checkmark color

    self.title= [[NSString alloc]init];
    
   self.topItems= [[NSMutableArray alloc] initWithObjects:@"Today", @"Yesterday",@"August,10th,2014",@"Today",@"Today",@"Today",nil];
    NSMutableArray *training =[NSMutableArray new];
    [training addObject:[[NSArray alloc] initWithObjects:@"Drink@completed",@"Vitamin@selected",@"Eat@selected",nil]];
    [training addObject:[[NSArray alloc] initWithObjects:@"Vitamin@selected", nil]];
    [training addObject:[[NSArray alloc] initWithObjects:@"Eat@completed", nil]];
    [training addObject:[[NSArray alloc] initWithObjects:@"Eat@completed", nil]];
    [training addObject:[[NSArray alloc] initWithObjects:@"Eat@completed", nil]];
    [training addObject:[[NSArray alloc] initWithObjects:@"Eat@completed", nil]];
    
    self.subItems=training;
    
  //  self.topItems = [[NSMutableArray alloc] initWithArray:[self topLevelItems]];
  //  self.subItems = [NSMutableArray new];
    self.currentExpandedIndex = -1;
    
       
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topItems count] + ((self.currentExpandedIndex > -1) ? [[self.subItems objectAtIndex:self.currentExpandedIndex] count] : 0);
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ParentCellIdentifier = @"ParentCell";
    static NSString *ChildCellIdentifier = @"ChildCell";
    
    BOOL isChild =
    self.currentExpandedIndex > -1
    && indexPath.row > self.currentExpandedIndex
    && indexPath.row <= self.currentExpandedIndex + [[self.subItems objectAtIndex:self.currentExpandedIndex] count];
    
    UITableViewCell *cell;
    
    if (isChild) {
        cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
    }
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ParentCellIdentifier];
    }
    
    if (isChild) {
       
        self.title= [[self.subItems objectAtIndex:self.currentExpandedIndex] objectAtIndex:indexPath.row - self.currentExpandedIndex - 1];
        NSArray *array=[self.title componentsSeparatedByString:@"@"];
        cell.detailTextLabel.text=[array objectAtIndex:0];
        if([[array objectAtIndex:1] isEqualToString:@"completed"]){
             cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"medal-26.png"]];
            [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];}
        
        if([[array objectAtIndex:1] isEqualToString:@"selected"]){
            cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkmarkgreen-25.png"]];
            [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];
        
        
        }
        
        
    }
    else {
        int topIndex = (self.currentExpandedIndex > -1 && indexPath.row > self.currentExpandedIndex)
        ? indexPath.row - [[self.subItems objectAtIndex:self.currentExpandedIndex] count]
        : indexPath.row;
        
        cell.textLabel.text = [self.topItems objectAtIndex:topIndex];
        cell.detailTextLabel.text = @"";
        [cell setAccessoryType:UITableViewCellAccessoryNone];

    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isChild =
    self.currentExpandedIndex > -1
    && indexPath.row > self.currentExpandedIndex
    && indexPath.row <= self.currentExpandedIndex + [[self.subItems objectAtIndex:self.currentExpandedIndex] count];
    
    if (isChild) {
        NSLog(@"A child was tapped, do what you will with it");
        return;
    }
    
    [self.myTableView beginUpdates];
    
    if (self.currentExpandedIndex == indexPath.row) {
        [self collapseSubItemsAtIndex:self.currentExpandedIndex];
       self.currentExpandedIndex = -1;
    }
    else {
        
        BOOL shouldCollapse = self.currentExpandedIndex > -1;
        
        if (shouldCollapse) {
            [self collapseSubItemsAtIndex:self.currentExpandedIndex];
        }
        
        self.currentExpandedIndex = (shouldCollapse && indexPath.row > self.currentExpandedIndex) ? indexPath.row - [[self.subItems objectAtIndex:self.currentExpandedIndex] count] : indexPath.row;
        
        [self expandItemAtIndex:self.currentExpandedIndex];
    }
    
    [self.myTableView endUpdates];
    
}

- (void)expandItemAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = [self.subItems objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [self.myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    // [indexPaths release];
}

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[self.subItems objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    //  [indexPaths release];
}




@end
