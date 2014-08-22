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
#import "BlurryModalSegue/BlurryModalSegue.h"
#import "AFNetworking.h"

@interface ScrollCardViewController ()
@property NSArray *myCards;
@property NSArray *myDirections;
@property NSArray *background;
@property NSString *sendCardTitle;
@property NSArray *icons;
@property NSDictionary *receivedData;
@property NSDictionary *icon;
@property int numberOfCards;
@end

@implementation ScrollCardViewController


@synthesize scrollView;

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
    
    //initial my cards for testing

    self.icons=[[NSArray alloc]initWithObjects:@"walking-100.png",
                     @"fish-100.png",
                     @"bunch_flowers-128.png",
                     @"vegan_food-100.png",
                     @"bed-100.png",
                     @"water-100.png",
                     nil];
    
    
    self.myCards= [[NSArray alloc]initWithObjects:@"Moderate exercise",
                   @"Take vitamin D",
                   @"Take echinacea",
                   @"Take probiotics",
                   @"Sleep 8 hrs",
                   @"Drink 64 ounce water",
                   nil];
    self.myDirections= [[NSArray alloc] initWithObjects:
                        @"Walk for 40 minutes today at 70 to 80 pencent of your Maximum aerobic heart rate (also VO2max). Don't know your VO2max rate? Tap the list button at the top-left corner. Use the VO2max Calculator to calculate your VO2max rate.",
                        @"For adults (age > 18): take 5000 IU today. For kids (age between 5 - 18): take 2500 IU today.For babies and toddlers (age < 5): take 35 IU per pound today.",
                        @"Take 800 mg of echinacea liquid extract or equivalent three times today. \\n\\n* Children and pregnant or breastfeeding women should not take echinacea unless doctors have approved it.",
                        nil];
    
      
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://localhost:3000/user_profile/53f1439d3b240c55ba4bb2a7" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        self.receivedData=responseObject;
        
        
        [self.view setNeedsDisplay];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //initialize and allocate your scroll view
    self.scrollView = [[UIScrollView alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height)];
    //set the paging to yes
    self.scrollView.pagingEnabled = YES;
    
    //lets create 10 views
    NSInteger numberOfViews = [self.myCards count];
    for (int i = 0; i < numberOfViews; i++) {
        
        //set the origin of the sub view
        CGFloat myOrigin = i * self.view.frame.size.width;
        
        //create the sub view and allocate memory
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(myOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //set the background to white color
        myView.backgroundColor = [UIColor whiteColor];
   
        
        UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom ];
        [butt setFrame:CGRectMake(100, 0, 220, 120)];

        [butt setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [butt setTitle:[NSString stringWithFormat:self.myCards[i], i] forState:UIControlStateNormal];
         butt.titleLabel.font =[UIFont boldSystemFontOfSize:25.0f];
        [butt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        [butt addTarget:self action:@selector(cardButton:)  forControlEvents:(UIControlEventTouchUpInside)];
        [myView addSubview:butt];
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90.0, 90.0)];
        icon.image=[UIImage imageNamed:[NSString stringWithFormat:self.icons[i], i] ];
        [myView addSubview:icon];
        //set the scroll view delegate to self so that we can listen for changes
        self.scrollView.delegate = self;
        //add the subview to the scroll view
        [self.scrollView addSubview:myView];
        
        
      
    }
    
    //set the content size of the scroll view, we keep the height same so it will only
    //scroll horizontally
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews,
                                               self.view.frame.size.height);
    
    //we set the origin to the 3rd page
    CGPoint scrollPoint = CGPointMake(self.view.frame.size.width * 2, 0);
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
    
    self.sendCardTitle= sender.titleLabel.text;
     [self performSegueWithIdentifier: @"CompleteCard" sender: self];
    NSLog(self.sendCardTitle);
    
 //  CardNoteViewController  *cardview = [[CardNoteViewController alloc] initWithNibName:@"second" bundle:nil];
  //  [self presentViewController:cardview animated:YES completion:^{}];
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CompleteCard"]) {
      //  RecipeDetailViewController *destViewController = segue.destinationViewController;
      //  destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
        
        CardCompleteNoteViewController *destViewController = segue.destinationViewController;
        destViewController.receivedCardTitle=self.sendCardTitle;
    
    }
}


@end
