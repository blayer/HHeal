//
//  CardNoteViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/4/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//
// this controller is to implement reporting a complished training 

#import "CardCompleteNoteViewController.h"
#import "BlurryModalSegue/BlurryModalSegue.h"
#import  "HHealParameter.h"
#import "AFNetworking.h"

@interface CardCompleteNoteViewController ()
@property UILabel *name;
@property UITextView *direction;
@property UITextView *note;
@property UIAlertView *completeAlert;
@property UIButton *clickedButton;
@property NSDictionary *mycard;
@end

@implementation CardCompleteNoteViewController

@synthesize receivedCard;


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
    NSLog(@"received data is %@",self.receivedCard);
    
    
    
   self.completeAlert = [[UIAlertView alloc] initWithTitle:@"Training Card Completed"
                                                      message:@"Are you sure you have completed this training today?"
                                                     delegate:self
                                            cancelButtonTitle:@"Yes"
                                            otherButtonTitles:@"No", nil];
    
    
    ///////////////////cominication////////////////
    //Read in training card's info by query id
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingCard];
    if(self.receivedCard!=nil)
    {[url appendString:self.receivedCard];}
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        self.mycard=responseObject;
       //set self.mycard before adding views
        [self addTrainingCardView];
        [self.view setNeedsDisplay];
        
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
-(void) addTrainingCardView
{
    NSString *title= [self.mycard objectForKey:@"title"];
    NSString *progress=[self.mycard objectForKey:@"progress"];
    self.direction=[self.mycard objectForKey:@"direction"];
    self.note=[self.mycard objectForKey:@"note"];
    //set up title label
    CGRect nameFrame = CGRectMake(0.0f, 40.0f, 320.0f, 50.0f);
    self.name= [[UILabel alloc] initWithFrame:nameFrame];
    
    
    //title received from source view controller
    
    self.name.text = [NSString stringWithFormat:title];
    self.name.font = [UIFont boldSystemFontOfSize:25.0f];
    self.name.textAlignment =  NSTextAlignmentCenter;
    self.name.textColor=[UIColor lightGrayColor];
    
    //  self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:self.background[i], i]]]
    
    [self.view addSubview:self.name];
    
    
    
    CGRect directionFrame =CGRectMake(0.0f, 90.0f, self.view.frame.size.width,self.view.frame.size.height-90.0f);
    UITextView *direction =[[UITextView alloc] initWithFrame:directionFrame];
    direction.text =self.direction;
    direction.textAlignment=NSTextAlignmentLeft;
    [direction setFont:[UIFont fontWithName:@"arial" size:20.0f]];
    [direction setEditable:NO];
    [direction setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:direction];
    
    
    // create a button to report training completion
    
    CGRect reportFrame =CGRectMake(250.0f, 20.0f, 50.0f, 50.0f);
    UIButton *reportButton =[[UIButton alloc]initWithFrame:reportFrame];
    if (progress==nil)
        NSLog(@"progress is nil");
    if([progress isEqualToString:@"selected"]){
        [reportButton setImage:[UIImage imageNamed:@"medal_grey-48.png"] forState:UIControlStateNormal];
        [reportButton addTarget:self action:@selector(ButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];}
    if([progress isEqualToString:@"completed"])
    {
        [self.clickedButton setImage:[UIImage imageNamed:@"medal_yellow-48.png"] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:reportButton];
}

-(void) ButtonClicked:(UIButton *) sender
{  // [sender setImage:[UIImage imageNamed:@"medal_yellow-48.png"] forState:UIControlStateNormal];
    self.clickedButton=sender;
    [self.completeAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        
        NSMutableString *url=[NSMutableString new];
        [url appendString:HHealURL];
        [url appendString:@"/user_profile/"];
        [url appendString:self.receivedCard];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            [self.clickedButton setImage:[UIImage imageNamed:@"medal_yellow-48.png"] forState:UIControlStateNormal];
            
            [self.view setNeedsDisplay];
            
            UIAlertView *completeAlert = [[UIAlertView alloc] initWithTitle:@"Successful!"
                                                                    message:@"Training Card Completed."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
            [completeAlert show];
            
            [self performSegueWithIdentifier: @"CompleteBacktoMainPage" sender: self];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data, Please check your connection."
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [errorAlert show];
            NSLog(@"Error: %@", error);
        }];

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
