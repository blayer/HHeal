//
//  CardNoteViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/4/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "CardNoteViewController.h"
#import "BlurryModalSegue/BlurryModalSegue.h"

@interface CardNoteViewController ()
@property NSArray *cardName;
@property NSArray *cardDirection;
@property NSArray *cardNote;
@property UILabel *name;
@property UITextView *direction;
@property UITextView *note;
@property int cardIdentifier;
@end

@implementation CardNoteViewController

@synthesize receivedCardTitle;


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
    NSLog(@"received data is %@",self.receivedCardTitle);
    self.cardIdentifier=0;
    // Do any additional setup after loading the view.
    self.cardName= [[NSArray alloc]initWithObjects:
                    @"Moderate exercise 40 mins",
                    @"Take vitamin D supplements 5000 IU",
                    @"Take echinacea extract 2400 mg",
                    @"string",
                    @"string",
                    @"string",
                    nil];
    self.cardDirection= [[NSArray alloc]initWithObjects:
                         @"Walk for 40 minutes today at 70 to 80 pencent of your Maximum aerobic heart rate (also VO2max). Don't know your VO2max rate? Tap the list button at the top-left corner. Use the VO2max Calculator to calculate your VO2max rate.",
                         @"For adults (age > 18): take 5000 IU today.For kids (age between 5 - 18):\n take 2500 IU today.For babies and toddlers (age < 5):\n take 35 IU per pound today.",
                         @"Take 800 mg of echinacea liquid extract or equivalent three times today. \\n\\n* Children and pregnant or breastfeeding women should not take echinacea unless doctors have approved it.",
                         @"string",
                         @"string",
                         @"string",
                         nil];
    self.cardNote= [[NSArray alloc]initWithObjects:
                    @"Research on exercise and immunology has shown that regular, moderate exercise enhances the immune system. Researchers from the University of South Carolina and the University of Massachusetts examined rates of infections in the upper respiratory tract among 641 healthy inactive and moderately active adults ages 20 to 70 for one year. They found that those who participated in moderate physical activity reduced their cold risk by about 30 percent. Another study showed that people who walked at 70 to 75 percent of their VO2max for 40 minutes per day reported half as many sick days because of colds or sore throats compared to people who didn't exercise. The study was done by Dr. David Nieman, one of the country's most respected authorities in exercise immunology. \\n\\nExercise has been shown to increase the production of macrophages, which are cells that attack the kinds of bacteria that can trigger upper respiratory diseases. More recent studies show that there are actually physiological changes in the immune system that happen when a person exercises. Cells that promote immunity circulate through the system more rapidly, and they're capable of killing both viruses and bacteria. After exercising, the body returns to normal within a few hours, but a regular exercise routine appears to extend periods of immunity. \\n\\n* This complementary health approach has not been approved by the National Institutes of Health. \\n\\n** Please use your own discretion when using this training approach.",
                    @"Vitamin D has been shown to be a highly effective way to avoid flu. In a study conducted among 430 children, those who took as low as 1200 IU Vitamin D were shown to be 42 percent less likely to come down with the flu. Another study conducted among adults showed similar results, those who maintained adequate vitamin D levels were 50% less likely to get flu. \\n\\nAn ideal way to optimize your vitamin D levels is to get regular sun exposure. However, during winter seasons and especially in some northern countries, the levels of sun are so weak that your body makes no vitamin D at all. The GrassrootsHealth - an organization that has greatly contributed to the current knowledge on vitamin D through their D Action Study made a recommendation on vitamin D dosage: for children under age of 5, take 35 units per pound per day. For children between 5 and 18, take 2500 units per day. For adults (including pregnant women), take 5000 units per day. \\n\\n* This complementary health approach has not been approved by the National Institutes of Health. \\n\\n** Please use your own discretion when using this training approach. \\n\\n*** These statements have not been evaluated by the Food and Drug Administration. This supplement is not intended to diagnose, treat, cure, or prevent any disease.",
                    @"Echinacea is a flowering plant that grows throughout the U.S. and Canada. Studies have shown that it increases the number of white blood cells and boosts the activity of other immune cells. In a recent study, 755 healthy people took echinacea or a placebo for four months. Those who took echinacea had 20 percent fewer colds. \\n\\n* This complementary health approach has not been approved by the National Institutes of Health. \\n\\n** Please use your own discretion when using this training approach. \\n\\n*** These statements have not been evaluated by the Food and Drug Administration. This supplement is not intended to diagnose, treat, cure, or prevent any disease.",
                    @"string",
                    @"string",
                    @"string",
                    nil];
    //set up title label
    CGRect nameFrame = CGRectMake(0.0f, 40.0f, 320.0f, 50.0f);
    self.name= [[UILabel alloc] initWithFrame:nameFrame];
    
    
    //title received from source view controller
    
    
    self.name.text = [NSString stringWithFormat:self.receivedCardTitle];
    self.name.font = [UIFont boldSystemFontOfSize:25.0f];
    self.name.textAlignment =  NSTextAlignmentCenter;
    self.name.textColor=[UIColor lightGrayColor];
    
  //  self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:self.background[i], i]]]
    
    [self.view addSubview:self.name];
    
    
    
    CGRect directionFrame =CGRectMake(0.0f, 90.0f, self.view.frame.size.width,self.view.frame.size.height-90.0f);
    UITextView *direction =[[UITextView alloc] initWithFrame:directionFrame];
    direction.text = [NSString stringWithFormat:self.cardNote[self.cardIdentifier], self.cardIdentifier];
    direction.textAlignment=NSTextAlignmentLeft;
    [direction setFont:[UIFont fontWithName:@"arial" size:20.0f]];
    [direction setEditable:NO];
    [direction setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:direction];
    
    
    // create a button to report training completion
    
    CGRect reportFrame =CGRectMake(220.0f, 20.0f, 100.0f, 30.0f);
    UIButton *reportButton =[[UIButton alloc]initWithFrame:reportFrame];
    [reportButton setTitle:@"Selected" forState:(UIControlStateNormal)];
    [reportButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    reportButton.titleLabel.font =[UIFont boldSystemFontOfSize:20.0f];
    [reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [reportButton addTarget:self action:@selector(cardButton:)  forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:reportButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(BlurryModalSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"card1"])
    { self.cardIdentifier=1;
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
