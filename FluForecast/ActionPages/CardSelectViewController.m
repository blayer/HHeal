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
@property NSMutableArray *selectedCards; // a array of all selected cards' titles
@end

@implementation CardSelectViewController

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {}


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
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
 /*   NSArray *selectedCardsJson=[defaults objectForKey:@"selectedCards"]; //this is a array of Json of all selected cards
     for (int i=0;i<[selectedCardsJson count]; i++)
     {     NSDictionary *item = [selectedCardsJson objectAtIndex:i];
         [self.selectedCards addObject:[item objectForKey:@"title"]];
     }
  
  */
    self.cardId=[NSMutableDictionary new];
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingCard];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        self.cardName=responseObject;
        
        NSDate *date= [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormat stringFromDate:date];
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
            
            
            NSLog(@"JSON: %@", responseObject);
            self.selectedCards=responseObject;
            
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data, Please check your connection."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            NSLog(@"Error: %@", error);
        }];
        
        [self.tableView reloadData];
        
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
    
    if([progress isEqualToString:@"selected"])
    {
         cell.imageView.image = [UIImage imageNamed:@"checkmarkgreen-32.png"];
        [cell.accessoryView setFrame:CGRectMake(0, 0, 25, 25)];
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
    [self performSegueWithIdentifier: @"SelectedCard" sender: self];
   // NSLog(selectedCell.detailTextLabel.text);
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (self.view.frame.size.height/8);// set the row number as 8
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectedCard"]) {

        CardNoteViewController *destViewController = segue.destinationViewController;
        destViewController.receivedCard=self.sendCard;
        
    }
}



-(BOOL) checkCardsIn: (NSMutableArray *) selectedCards from:(NSDictionary*) currentCard
{
    NSString *title= [currentCard objectForKey:@"title"];
    for(int i=0; i<[selectedCards count];i++)
    { NSDictionary *card=[selectedCards objectAtIndex:i];
        
        if([title isEqualToString:[card objectForKey:@"title"]])
        {  return YES;
        }
        
    }
    
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
