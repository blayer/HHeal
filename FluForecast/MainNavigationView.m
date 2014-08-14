//
//  MainNavigationView.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/22/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "MainNavigationView.h"
#import "BlurryModalSegue/BlurryModalSegue.h"

@interface MainNavigationView ()

@end

@implementation MainNavigationView



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString * identifier;
    
    switch (indexPath.row) {
        case 0:
            identifier=@"HomeSegue";
            break;
        case 1:
            identifier=@"HomeSegue";
            break;
        case 2:
            identifier=@"RiskHistorySegue";
            break;
            
        case 3:
            identifier=@"TrainingLogSegue";
            break;
            
        case 4:
            identifier=@"CalculatorSegue";
            break;
            
        case 5:
           identifier=@"ProfileSegue";
            break;

         case 6:
          identifier=@"FeedbackSegue";
           break;
         case 7:
          identifier=@"AboutSegue";
           break;
 
    }


    return identifier;

}


- (NSString *) segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath
{
    NSString * identifier;
    
   
    
    
    return identifier;
    
}


- (void) configureLeftMenuButton:(UIButton *)button
{
    CGRect frame =button.frame;
    frame.origin=(CGPoint){0,0};

    frame.size= (CGSize){40,40};
    
    button.frame=frame;
    
    
    
    [button setImage:[UIImage imageNamed:@"menu-32.png"] forState:UIControlStateNormal];

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
