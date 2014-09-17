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
#import "HHealParameter.h"

@interface ScrollCardViewController ()
@property NSArray *myCards;
@property NSArray *background;
@property NSString *sendCard;
@property NSDictionary *icons;
@property int numberOfCards;
@property NSMutableDictionary *cardId;
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
    
   NSDate *date= [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    //initial my cards for testing

    self.icons=@{@"walking":@"walking-100.png",
                 @"vataminD":@"fish-100.png",
                 @"flower":@"bunch_flowers-128.png",
                 @"food":@"vegan_food-100.png",
                 @"sleep":@"bed-100.png",
                 @"water":@"water-100.png"};
    
    NSMutableString *url=[NSMutableString new];
    [url appendString:HHealURL];
    [url appendString:@"/user_trainingcard/"];
    [url appendString:token];
    [url appendString:@"/"];
    [url appendString:dateString];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        self.myCards=responseObject;
        [self addScrollview];
        //adding scrolls
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
    
 
}


-(void) addScrollview {
    
    
    NSInteger numberOfViews = [self.myCards count];
    for (int i = 0; i < numberOfViews; i++) {
        
        NSDictionary *card=self.myCards[i];
        NSString *title=[card objectForKey:@"title"];
        NSString *idnumber=[card objectForKey:@"_id"];
        
        [self.cardId setObject:idnumber forKey:title];
        
        //set the origin of the sub view
        CGFloat myOrigin = i * self.view.frame.size.width;
        
        //create the sub view and allocate memory
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(myOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //set the background to white color
        myView.backgroundColor = [UIColor whiteColor];
        
        UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom ];
        [butt setFrame:CGRectMake(100, 0, 220, 120)];
        
        [butt setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [butt setTitle:[NSString stringWithFormat:title, i] forState:UIControlStateNormal];
        butt.titleLabel.font =[UIFont boldSystemFontOfSize:25.0f];
        [butt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [butt addTarget:self action:@selector(cardButton:)  forControlEvents:(UIControlEventTouchUpInside)];
        [myView addSubview:butt];
        
        NSString *iconName=[self.icons objectForKey:title];
        
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90.0, 90.0)];
        icon.image=[UIImage imageNamed:[NSString stringWithFormat:iconName, i] ];
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
    self.sendCard=[self.cardId objectForKey:sender.titleLabel.text];
     [self performSegueWithIdentifier: @"CompleteCard" sender: self];
    NSLog(self.sendCard);
    
 //  CardNoteViewController  *cardview = [[CardNoteViewController alloc] initWithNibName:@"second" bundle:nil];
  //  [self presentViewController:cardview animated:YES completion:^{}];
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CompleteCard"]) {
      //  RecipeDetailViewController *destViewController = segue.destinationViewController;
      //  destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
        
        CardCompleteNoteViewController *destViewController = segue.destinationViewController;
        destViewController.receivedCard=self.sendCard;
    
    }
}


@end
