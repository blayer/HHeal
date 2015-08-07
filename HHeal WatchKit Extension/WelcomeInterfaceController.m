//
//  WelcomeInterfaceController.m
//  HHeal
//
//  Created by Changkun Zhao on 8/6/15.
//  Copyright (c) 2015 Changkun Zhao. All rights reserved.
//

#import "WelcomeInterfaceController.h"
#import "HHealParameter.h"
#import "PNChart.h"


@interface WelcomeInterfaceController ()

@end

@implementation WelcomeInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self loadToken];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)refreshClicked {
    [self loadToken];
    
}
- (void) loadToken{
    NSString *token=[[[NSUserDefaults alloc] initWithSuiteName: @"group.HHeal"] objectForKey:@"token"];
    if(token!=nil)
    {   [self.welcomeLabel setTextColor:PNGreen];
        [self.welcomeLabel setText:@"Welcome to HHeal"];
    }
    else
    {   [self.welcomeLabel setTextColor:PNRed];
        [self.welcomeLabel setText:@"Please login first."];}
}

@end



