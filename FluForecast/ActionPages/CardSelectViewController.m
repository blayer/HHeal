//
//  CardSelectViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/9/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "CardSelectViewController.h"
#import "CardNoteViewController.h"
#import "HHealParameter.h"
#import "AFNetworking.h"

@interface CardSelectViewController ()
@property NSArray *cardName;
@property NSString *sendCard;
@property NSDictionary *cardData;
@property NSMutableDictionary *cardId;
@property NSString *progress;
@property NSMutableArray *selectedCards; // a array of all selected cards' titles
@end

@implementation CardSelectViewController

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {
    [self buildView];
}


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
      //Read in training card's info by query id, server should response an array with JSON elements
    
    [self buildView];

}

-(void) buildView
{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    [self.view setUserInteractionEnabled:NO];
    
    [activityIndicator startAnimating];
    self.cardId=[NSMutableDictionary new];
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingCard];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activityIndicator stopAnimating];
        NSLog(@"ALl Cards=JSON: %@", responseObject);
        self.cardName=responseObject;
        
        NSDate *date= [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token=[defaults objectForKey:@"token"];
        NSMutableString *url=[NSMutableString new];
        [url appendString:HHealURL];
        [url appendString:@"/user_trainingcard/"];
        [url appendString:token];
        [url appendString:@"/"];
        [url appendString:dateString];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            

            NSLog(@"Selected Cards=JSON: %@", responseObject);
            self.selectedCards=responseObject;
            [self.tableView reloadData];
            [self.view setUserInteractionEnabled:YES];

            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [activityIndicator stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data, Please check your connection."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            NSLog(@"Error: %@", error);
            [self.view setUserInteractionEnabled:YES];

        }];
        
        // [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data, Please check your connection."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cardName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    self.cardData=[self.cardName objectAtIndex:indexPath.row];
    
    NSString *title= [self.cardData objectForKey:@"title"];
    NSString *progress=nil;
    if ([self checkCardsIn:self.selectedCards from:self.cardData])
    {
        progress=@"selected";
    }
    else
    {
        progress=@"unselected";
    }
    NSString *trainingId=[self.cardData objectForKey:@"_id"];
    if([self.cardName count]!=0)
    {
    [self.cardId setObject:trainingId forKey:title];
    }
    cell.textLabel.text =title;
    cell.textLabel.font=[UIFont boldSystemFontOfSize:13.0f];
    
    if([progress isEqualToString:@"selected"])
    {
         cell.imageView.image = [UIImage imageNamed:@"checkmarkgreen-32.png"];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 20, 20)];
        cell.detailTextLabel.text=@"selected";

    }
    
 //if([[array objectAtIndex:1] isEqualToString:@"unselected"])
   else
    {
    cell.imageView.image = [UIImage imageNamed:@"checkmarkgrey-32.png"];
        [cell.imageView setFrame:CGRectMake(0.0f, 0.0f,25.0f, 25.0f)];
    cell.detailTextLabel.text=@"unselected";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];

    
    self.sendCard=[self.cardId objectForKey:selectedCell.textLabel.text];
    self.progress=selectedCell.detailTextLabel.text;
    [self performSegueWithIdentifier: @"SelectedCard" sender: self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (self.view.frame.size.height/8);// set the row number as 8
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectedCard"]) {

        CardNoteViewController *destViewController = segue.destinationViewController;
        destViewController.receivedCard=self.sendCard;
        destViewController.receivedProgress=self.progress;
}}

-(BOOL) checkCardsIn: (NSMutableArray *) selectedCards from:(NSDictionary*) currentCard
{
    NSString *title= [currentCard objectForKey:@"title"];
    for(int i=0; i<[selectedCards count];i++)
    { NSDictionary *card=[selectedCards objectAtIndex:i];
        
        if([title isEqualToString:[card objectForKey:@"title"]])
        {  return YES;
        } }
    return NO;
}

@end
