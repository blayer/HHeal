//
//  WelcomeInterfaceController.h
//  HHeal
//
//  Created by Changkun Zhao on 8/6/15.
//  Copyright (c) 2015 Changkun Zhao. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface WelcomeInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *welcomeLabel;
- (IBAction)refreshClicked;

@end
