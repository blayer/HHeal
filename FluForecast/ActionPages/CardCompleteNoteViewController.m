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
#import "ActivityHub.h"



#define startPositionY  ((float) 40.0)


@interface CardCompleteNoteViewController ()
@property UILabel *name;
@property UITextView *direction;
@property NSString *note;
@property UIAlertView *completeAlert;
@property NSDictionary *mycard;
@property UIButton *reportButton;
@property ActivityHub *completeView;
@end

@implementation CardCompleteNoteViewController



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
    self.completeView=[[ActivityHub alloc]initWithFrame:CGRectMake(75, 155, 170, 170)];
    [self.completeView setLabelText:@"Training Completed"];
    [self.completeView setImage:[UIImage imageNamed:@"checked_checkbox-48.png"]];
    //=====================================//
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    //========================================//
    
   self.completeAlert = [[UIAlertView alloc] initWithTitle:@"Training Card Completed"
                                                      message:@"Congratuation! You have accomplished a large step toward a healthy life.Please confirm this action."
                                                     delegate:self
                                            cancelButtonTitle:@"Yes"
                                            otherButtonTitles:@"No", nil];
    
    
    ///////////////////cominication////////////////
    //Read in training card's info by query id
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingCard];

    if(self.receivedTrainingCardId!=nil)
    {[url appendString:self.receivedTrainingCardId];}
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activityIndicator stopAnimating];
        NSLog(@"JSON: %@", responseObject);
        self.mycard=responseObject;
       //set self.mycard before adding views
        [self addTrainingCardView];
        [self.view setUserInteractionEnabled:YES];
        [self.view setNeedsDisplay];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) addTrainingCardView
{
    NSString *title= [self.mycard objectForKey:@"title"];
    self.direction=[self.mycard objectForKey:@"direction"];
    NSString *extraNote=[self.mycard objectForKey:@"note"];
    self.note=[NSString stringWithFormat:@"Direction:\n\n%@\n\n\nMore details:\n\n%@",self.direction,extraNote];
    //set up title label
    CGRect nameFrame = CGRectMake(20.0f, startPositionY, 280.0f, 50.0f);
    self.name= [[UILabel alloc] initWithFrame:nameFrame];
    
    
    //title received from source view controller
    
    self.name.text = title;
    self.name.font = [UIFont boldSystemFontOfSize:25.0f];
    self.name.textAlignment =  NSTextAlignmentCenter;
    self.name.textColor=[UIColor lightGrayColor];
    [self.name setAdjustsFontSizeToFitWidth:YES];
    
    //  self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:self.background[i], i]]]
    
    [self.view addSubview:self.name];
    
    
    
    CGRect directionFrame =CGRectMake(10.0f, startPositionY+50.0, self.view.frame.size.width-20.0f,self.view.frame.size.height-90.0f);
    UITextView *direction =[[UITextView alloc] initWithFrame:directionFrame];
    direction.text =self.note;
    direction.textAlignment=NSTextAlignmentLeft;
    [direction setFont:[UIFont fontWithName:@"arial" size:16.0f]];
    [direction setEditable:NO];
    [direction setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:direction];
    // create a button to report training completion
    
    CGRect reportFrame =CGRectMake(220.0f, startPositionY-30.0, 100.0f, 50.0f);
    self.reportButton =[[UIButton alloc]initWithFrame:reportFrame];
    if (self.progress==nil)
        NSLog(@"progress is nil");
    if([self.progress isEqualToString:@"selected"]){
        [self.reportButton setImage:[UIImage imageNamed:@"ribbon_grey-48.png"] forState:UIControlStateNormal];
        self.reportButton.imageView.frame=CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
        [self.reportButton addTarget:self action:@selector(ButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];}
    if([self.progress isEqualToString:@"completed"])
    {
        [self.reportButton setImage:[UIImage imageNamed:@"ribbon_yellow-48.png"] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.reportButton];
}

-(void) ButtonClicked:(UIButton *) sender
{
    [self.completeAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        
        NSMutableString *url=[NSMutableString new];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token =[defaults objectForKey:@"token"];

        [url appendString:HHealURL];
        [url appendString:GetUserAllCards];
        [url appendString:token];
        [url appendString:@"/"];
        [url appendString:self.receivedCardId];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager PUT:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
         //   [self.clickedButton setImage:[UIImage imageNamed:@"ribbon_yellow-48.png"] forState:UIControlStateNormal];
            [self.reportButton setImage:[UIImage imageNamed:@"ribbon_yellow-48.png"] forState:UIControlStateNormal];
            [self.view setNeedsDisplay];
            [self.view addSubview:self.completeView];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.completeView removeFromSuperview];                
            });
          //  [self performSegueWithIdentifier: @"CompleteBacktoMainPage" sender: self];

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
