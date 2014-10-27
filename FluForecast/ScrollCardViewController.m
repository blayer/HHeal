//
//  ScrollCardViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/1/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ScrollCardViewController.h"
#import "CardCompleteNoteViewController.h"
#import "PNColor.h"
#import "AFNetworking.h"
#import "HHealParameter.h"

@interface ScrollCardViewController ()
@property NSArray *myCards;
@property NSArray *background;
@property NSDictionary *sendCard;
@property NSDictionary *icons;
@property int numberOfCards;
@property NSMutableDictionary *cardId;
@end

@implementation ScrollCardViewController


@synthesize scrollView;

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
 
}
-(void) viewWillAppear:(BOOL)animated
{
    [self buildView];
    [self.view setNeedsDisplay];}

-(void) buildView
{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    self.cardId=[NSMutableDictionary new];
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    //initial my cards for testing
    
    self.icons=@{@"welcome":@"user-32.png",
                 @"Moderate exercise 40 mins.":@"walking-100.png",
                 @"Take vitamin D supplements 5000 IU":@"fish-100.png",
                 @"Take echinacea extract 2400 mg":@"bunch_flowers-128.png",
                 @"Take probiotics":@"vegan_food-100.png",
                 @"Sleep 8 hrs.":@"bed-100.png",
                 @"Drink 8 8-ounce glasses of water":@"water-100.png"};
    
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_trainingcard/"];
    [url appendString:token];
    [url appendString:@"/"];
    [url appendString:dateString];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ScrollView JSON: %@", responseObject);
        [activityIndicator stopAnimating];
        self.myCards=responseObject;
        
        if([self.myCards count]!=0)
        {  NSDictionary *card=[self.myCards objectAtIndex:0];}
        //    [defaults setObject:self.myCards forKey:@"selectedCards"];
        [self addScrollview];
        //adding scrolls
        [self.view setNeedsDisplay];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [activityIndicator stopAnimating];
        
    }];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //initialize and allocate your scroll view
    self.scrollView = [[UIScrollView alloc]
                       initWithFrame:CGRectMake(0, 0,
                                                self.view.frame.size.width,
                                                self.view.frame.size.height)];
    //set the paging to yes
    self.scrollView.pagingEnabled = YES;
    
}

-(void) addScrollview {
    
    NSInteger numberOfViews = [self.myCards count];
    
    for (int i = 0; i < numberOfViews; i++) {
        
        NSDictionary *card=self.myCards[i];
        NSString *title=[card objectForKey:@"title"];
        NSString *cardId=[card objectForKey:@"_id"];
        NSString *trainingCardID=[card objectForKey:@"trainingcard_id"];
        NSString *progress=[card objectForKey:@"progress"];
        NSDictionary *cardInfo=@{@"_id":cardId,
                                 @"trainingcard_id":trainingCardID,
                                 @"progress":progress};
        [self.cardId setObject:cardInfo forKey:title];
        
        //set the origin of the sub view
        CGFloat myOrigin = i * self.view.frame.size.width;
        
        //create the sub view and allocate memory
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(myOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //set the background to white color
        myView.backgroundColor = [UIColor whiteColor];
        
        UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom ];
        [butt setFrame:CGRectMake(290, 40 , 30,30 )];
        
        UIImage *disclosure = [UIImage imageNamed:@"forward-50.png"];
        [butt setImage:disclosure forState:UIControlStateNormal];
        
        [butt setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [butt setTitle:title forState:UIControlStateNormal];
         butt.titleLabel.font =[UIFont boldSystemFontOfSize:18.0f];
        [butt setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        butt.titleLabel.adjustsFontSizeToFitWidth = TRUE;

        [butt setBackgroundColor:[UIColor whiteColor]];
        
        [butt addTarget:self action:@selector(cardButton:)  forControlEvents:(UIControlEventTouchUpInside)];
        [myView addSubview:butt];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 25 , 220,60 )];
        [titleLabel setText:title];
        titleLabel.adjustsFontSizeToFitWidth=YES;
        [titleLabel setTextColor:[UIColor grayColor]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [myView addSubview:titleLabel];
        
        
        
        NSString *iconName=[self.icons objectForKey:title];
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 60.0, 60.0)];
        icon.image=[UIImage imageNamed:[NSString stringWithFormat:iconName, i] ];
        
        UIImageView *ribbon=[[UIImageView alloc]initWithFrame:CGRectMake(35, 45, 40.0, 40.0)];
        ribbon.image=[UIImage imageNamed:@"ribbon_yellow-48.png"];
        
        
        [myView addSubview:icon];
        
        if([progress isEqualToString:@"completed"] )
        {[myView addSubview:ribbon];}
        //set the scroll view delegate to self so that we can listen for changes
        self.scrollView.delegate = self;
        //add the subview to the scroll view
        [self.scrollView addSubview:myView];
    }
    
    //set the content size of the scroll view, we keep the height same so it will only
    //scroll horizontally
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews,
                                             self.view.frame.size.height);
    
    //we set the origin to the first page
    CGPoint scrollPoint = CGPointMake(0, 0);
    //change the scroll view offset the the 3rd page so it will start from there
    [self.scrollView setContentOffset:scrollPoint animated:YES];
    
    [self.view addSubview:self.scrollView];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
    {
        
        //find the page number you are on
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        NSLog(@"Scrolling - You are now on page %i",page);
    }



    
    //dragging ends, please switch off paging to listen for this event
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
withVelocity:(CGPoint)velocity
targetContentOffset:(inout CGPoint *) targetContentOffset
    NS_AVAILABLE_IOS(5_0){
        
        //find the page number you are on
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        NSLog(@"Dragging - You are now on page %i",page);
        
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cardButton:(UIButton*)sender
{  
    NSLog(@"Button Clicked");
   self.sendCard=[self.cardId objectForKey:sender.titleLabel.text];
    if(!(self.sendCard==nil))
     [self performSegueWithIdentifier: @"CompleteCard" sender: self];
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CompleteCard"]) {
        
        CardCompleteNoteViewController *destViewController = segue.destinationViewController;
        destViewController.receivedCardId=[self.sendCard objectForKey:@"_id"];
        destViewController.receivedTrainingCardId=[self.sendCard objectForKey:@"trainingcard_id"];
        destViewController.progress=[self.sendCard objectForKey:@"progress"];

    
    }
}


@end
