//
//  CardSelectViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/9/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "CardSelectViewController.h"
#import "CardNoteViewController.h"

@interface CardSelectViewController ()
@property NSArray *cardName;
@property NSString *sendCardTitle;
@property NSString *cardData;
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
    // Do any additional setup after loading the view.
    
    self.cardName= [[NSArray alloc]initWithObjects:
                    @"Moderate exercise 40 mins@selected",
                    @"Take vitamin D supplements 5000 IU@unselected",
                    @"Take echinacea extract 2400 mg@selected",
                    @"string@unselected",
                    @"string@unselected",
                    @"string@unselected",
                    nil];
    
   // self.view.layer.cornerRadius=5;

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    self.cardData=[self.cardName objectAtIndex:indexPath.row];
    NSArray *array=[self.cardData componentsSeparatedByString:@"@"];
 
    cell.textLabel.text =[array objectAtIndex:0];
    
    if([[array objectAtIndex:1] isEqualToString:@"selected"])
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
    self.sendCardTitle=selectedCell.textLabel.text;
    [self performSegueWithIdentifier: @"SelectedCard" sender: self];
    NSString *test =selectedCell.detailTextLabel.text;
    NSLog(self.sendCardTitle);
   // NSLog(selectedCell.detailTextLabel.text);
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (self.view.frame.size.height/8);// set the row number as 8
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectedCard"]) {
        //  RecipeDetailViewController *destViewController = segue.destinationViewController;
        //  destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
        
        CardNoteViewController *destViewController = segue.destinationViewController;
        destViewController.receivedCardTitle=self.sendCardTitle;
        
    }
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
