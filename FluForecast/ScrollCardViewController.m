//
//  ScrollCardViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/1/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ScrollCardViewController.h"
#import "CardNoteViewController.h"
#import "PNColor.h"
#import "BlurryModalSegue/BlurryModalSegue.h"

@interface ScrollCardViewController ()
@property NSArray *myCards;
@property NSArray *myDirections;
@property NSArray *background;
@property NSString *sendCardTitle;
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
    self.background=[[NSArray alloc]initWithObjects:@"exercise.jpg",
                     @"vitamine.jpg",
                     @"echinacea.jpg",
                     nil];
    
    
    self.myCards= [[NSArray alloc]initWithObjects:@"Moderate exercise",
                   @"Take vitamin D",
                   @"Take echinacea",
              //     @"Take probiotics",
              //     @"Sleep 8 hrs",
              //     @"Drink 8 8-ounce glasses of water",
                   nil];
    self.myDirections= [[NSArray alloc] initWithObjects:
                        @"Walk for 40 minutes today at 70 to 80 pencent of your Maximum aerobic heart rate (also VO2max). Don't know your VO2max rate? Tap the list button at the top-left corner. Use the VO2max Calculator to calculate your VO2max rate.",
                        @"For adults (age > 18): take 5000 IU today. For kids (age between 5 - 18): take 2500 IU today.For babies and toddlers (age < 5): take 35 IU per pound today.",
                        @"Take 800 mg of echinacea liquid extract or equivalent three times today. \\n\\n* Children and pregnant or breastfeeding women should not take echinacea unless doctors have approved it.",
                        nil];
    
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
        
        //create a label and add to the sub view
   /*     CGRect cardFrame = CGRectMake(0.0f, 0.0f, 320.0f, 120.0f);
        UILabel *myLabel = [[UILabel alloc] initWithFrame:cardFrame ];
        
        myLabel.text = [NSString stringWithFormat:self.myCards[i], i];
        myLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        myLabel.textAlignment =  NSTextAlignmentCenter;
        myLabel.textColor=[UIColor lightGrayColor];
        
        myLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:self.background[i], i]]];*/
        
    /*    UIButton *cardButton=[[UIButton alloc]initWithFrame:cardFrame];
         cardButton.titleLabel.text=[NSString stringWithFormat:self.myCards[i], i];
         cardButton.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
         cardButton.titleLabel.textAlignment =  NSTextAlignmentCenter;
        cardButton.titleLabel.textColor=[UIColor whiteColor];
        cardButton.titleLabel.backgroundColor=[UIColor lightGrayColor];*/

        
       // [myView addSubview:myLabel];
        
        //create a ui textview to contain direction for each card
  /*      CGRect directionFrame =CGRectMake(0.0f, 80.0f, self.view.frame.size.width, 130.0f);
        UITextView *direction =[[UITextView alloc] initWithFrame:directionFrame];
        direction.text = [NSString stringWithFormat:self.myDirections[i], i];
        direction.textAlignment=NSTextAlignmentLeft;
        [direction setFont:[UIFont fontWithName:@"arial" size:18]];
        [direction setEditable:NO];
        [myView addSubview:direction];
        */
        
        
        UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom ];
        [butt setFrame:CGRectMake(0, 0, 320, 120)];
        [butt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:self.background[i], i]] forState:UIControlStateNormal];
        [butt setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];
        [butt setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [butt setTitle:[NSString stringWithFormat:self.myCards[i], i] forState:UIControlStateNormal];
         butt.titleLabel.font =[UIFont boldSystemFontOfSize:25.0f];
        [butt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        [butt addTarget:self action:@selector(cardButton:)  forControlEvents:(UIControlEventTouchUpInside)];
        [myView addSubview:butt];
        
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
     [self performSegueWithIdentifier: @"card1" sender: self];
    NSLog(self.sendCardTitle);
    
 //  CardNoteViewController  *cardview = [[CardNoteViewController alloc] initWithNibName:@"second" bundle:nil];
  //  [self presentViewController:cardview animated:YES completion:^{}];
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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"card1"]) {
      //  RecipeDetailViewController *destViewController = segue.destinationViewController;
      //  destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
        
        CardNoteViewController *destViewController = segue.destinationViewController;
        destViewController.receivedCardTitle=self.sendCardTitle;
    
    }
}


@end
