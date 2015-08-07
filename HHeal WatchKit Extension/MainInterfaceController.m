//
//  MainInterfaceController.m
//  HHeal
//
//  Created by Changkun Zhao on 8/6/15.
//  Copyright (c) 2015 Changkun Zhao. All rights reserved.
//
#import "MainInterfaceController.h"
#import "HHealParameter.h"
#import "PNChart.h"

@interface MainInterfaceController ()

@end

@implementation MainInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self.titleLabel setTextColor:PNGreenBlue];
    [self.localLabel setTextColor:PNBlue];
    [self.personalLabel setTextColor:PNGreen];
    // Configure interface objects here.
    
  
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.HHeal"];
    NSNumber* localRate=[defaults objectForKey:@"standardrate"];
    NSNumber* personalRate=[defaults objectForKey:@"personalrate"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    [self.localLabel setText:[formatter stringFromNumber:localRate]];
    [self.personalLabel setText:[formatter stringFromNumber:personalRate]];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



