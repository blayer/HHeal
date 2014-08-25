//
//  ContactUsViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 8/22/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ContactUsViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)showEmail:(id)sender;

@end
