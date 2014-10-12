//
//  CardNoteViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/4/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//
// This controller is to implement card selection and unselection
#import "CardNoteViewController.h"
#import "BlurryModalSegue/BlurryModalSegue.h"
#import "AFNetworking.h"
#import "HHealParameter.h"
#import "ActivityHub.h"

@interface CardNoteViewController ()
@property NSArray *cardNote;
@property UILabel *name;
@property NSString *note;
@property UIAlertView *selectAlert;
@property UIAlertView *unselectAlert;
@property NSDictionary *myCard;
@property NSString  *progress;
@property NSMutableArray *selectedCards;
@property ActivityHub *completeView;

@end

@implementation CardNoteViewController

@synthesize receivedCard; //received data as a trainingcard id


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
    [self.completeView setLabelText:@"Training scheduled."];
    [self.completeView setImage:[UIImage imageNamed:@"checked_checkbox-48.png"]];
    //===================================
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    [self.view setUserInteractionEnabled:NO];
    [activityIndicator startAnimating];
    //====================================
    
    self.progress=self.receivedProgress;
    
    self.selectAlert = [[UIAlertView alloc] initWithTitle:@"Training Card Selected"
                                                    message:@"Are you sure you want to select this training card?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    
    self.unselectAlert = [[UIAlertView alloc] initWithTitle:@"Training Card Unselected"
                                                  message:@"Are you sure you want to unselect this training card?"
                                                 delegate:self
                                        cancelButtonTitle:@"Yes"
                                        otherButtonTitles:@"No", nil];

    // Do any additional setup after loading the view.
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:GetTrainingCard];
    
    if(self.receivedCard!=nil)
    {[url appendString:self.receivedCard];}
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [activityIndicator stopAnimating];
        NSLog(@"JSON: %@", responseObject);
        self.myCard=responseObject;
        //set self.mycard before adding views
        
        [self addTraingCardView];
        [self.view setNeedsDisplay];
        [self.view setUserInteractionEnabled:YES];

        
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


-(void) addTraingCardView
{
    
    //set up title label
    CGRect nameFrame = CGRectMake(20.0f, 60.0f, 280.0f, 50.0f);
    self.name= [[UILabel alloc] initWithFrame:nameFrame];
    
    
    //title received from source view controller
    NSString *title=[self.myCard objectForKey:@"title"];
    NSString *direction=[self.myCard objectForKey:@"direction"];
    NSString *extraNote=[self.myCard objectForKey:@"note"];
    self.note=[NSString stringWithFormat:@"Direction:\n\n%@\n\n\nMore details:\n\n%@",direction,extraNote];
    self.name.text = title;
    self.name.font = [UIFont boldSystemFontOfSize:25.0f];
    self.name.textAlignment =  NSTextAlignmentCenter;
    self.name.textColor=[UIColor blackColor];
    [self.name setAdjustsFontSizeToFitWidth:YES];

    [self.view addSubview:self.name];
    
    
    
    CGRect noteFrame =CGRectMake(10.0f, 120.0f, self.view.frame.size.width-20.0f,self.view.frame.size.height-120.0f);
    UITextView *note =[[UITextView alloc] initWithFrame:noteFrame];
    note.text =self.note;
    note.textAlignment=NSTextAlignmentLeft;
    [note setFont:[UIFont fontWithName:@"arial" size:16.0f]];
    [note setEditable:NO];
    [note setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:note];
    
    
    // create a button to report training completion
    
    CGRect reportFrame =CGRectMake(250.0f, 30.0f, 50.0f, 50.0f);
    UIButton *reportButton =[[UIButton alloc]initWithFrame:reportFrame];
    
    if([self.progress isEqualToString:@"unselected"] )
        [reportButton setImage:[UIImage imageNamed:@"checkmarkgrey-32.png"] forState:UIControlStateNormal];
    
    else
    {
        [reportButton setImage:[UIImage imageNamed:@"checkmarkgreen-32.png"] forState:UIControlStateNormal];
    }
    
    [reportButton addTarget:self action:@selector(ButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // [reportButton addTarget:self action:@selector(cardButton:)  forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:reportButton];
}

-(void) ButtonClicked:(UIButton *) sender
{  // [sender setImage:[UIImage imageNamed:@"checkmarkgreen-32.png"] forState:UIControlStateNormal];
    if ([self.progress isEqualToString:@"unselected"])
    { [self.selectAlert show];}
    else if([self.progress isEqualToString:@"selected"])
    { [self.unselectAlert show];}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([self.progress isEqualToString:@"unselected"]){
    if([title isEqualToString:@"Yes"])
    {
        NSString *trainingCardId=[self.myCard objectForKey:@"_id"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token =[defaults objectForKey:@"token"];
        NSString *agegroup=[defaults objectForKey:@"agegroup"];
        NSDate *date= [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        NSString *dateString = [dateFormatter stringFromDate:date];
     
        
        NSMutableString *url=[NSMutableString new];
        [url appendString:HHealURL];
        [url appendString:@"/user_trainingcard/"];
        [url appendString:token];
        [url appendString:@"/"];
        [url appendString:dateString];
        [url appendString:@"/"];
        [url appendString:trainingCardId];
        
        NSDictionary *parameters=@{@"agegroup":agegroup};
        
        NSLog(@"JSON: %@", agegroup);
     //   NSDictionary *parameter
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            [self.view addSubview:self.completeView];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.completeView removeFromSuperview];
                [self performSegueWithIdentifier: @"BacktoSelectPage" sender: self];

            });
    
            NSDictionary *addedCard=responseObject;
            [self.selectedCards addObject:addedCard];
            
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
      else if([title isEqualToString:@"No"])
      {
      }}
    
   else if ([self.progress isEqualToString:@"selected"]){
        if([title isEqualToString:@"Yes"])
        {
            NSString *trainingCardId=[self.myCard objectForKey:@"_id"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token =[defaults objectForKey:@"token"];
            NSDate *date= [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSString *dateString = [dateFormatter stringFromDate:date];
          
            
            NSMutableString *url=[NSMutableString new];
            [url appendString:HHealURL];
            [url appendString:@"/user_trainingcard/"];
            [url appendString:token];
            [url appendString:@"/"];
            [url appendString:dateString];
            [url appendString:@"/"];
            [url appendString:trainingCardId];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager DELETE :url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
               
                if ([[responseObject objectForKey:@"error"] length]!=0) {
                    
                    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"You can not unselect this schedule."
                                                                         message:@"As you already completed this training schedule today, you can not unselect it right now."
                                                                        delegate:nil
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles:nil];
                    [Alert show];
                    
                }
                else {
                [self.view addSubview:self.completeView];
                double delayInSeconds = 1.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.completeView removeFromSuperview];
                    [self performSegueWithIdentifier: @"BacktoSelectPage" sender: self];
                });}
                
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
        else if([title isEqualToString:@"No"])
        {
            //  NSLog(@"Button 2 was selected.");
        }}
    
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


@end
