//
//  ContactUsViewController.m
//  FluForecast
//
//  Created by Changkun Zhao on 8/22/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ContactUsViewController.h"
#import <MessageUI/MessageUI.h>

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

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
    
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    
    [mailController setSubject:@"my subject"];
    [mailController setMessageBody:@"my message" isHTML:NO];
    
    mailController.mailComposeDelegate =self;
    
    UINavigationController *myNavController = [self navigationController];
    
    if ( mailController != nil ) {
        if ([MFMailComposeViewController canSendMail]){
            [myNavController presentModalViewController:mailController animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
