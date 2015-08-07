//
//  MainInterfaceController.h
//  HHeal
//
//  Created by Changkun Zhao on 8/6/15.
//  Copyright (c) 2015 Changkun Zhao. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface MainInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *localLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *personalLabel;

@end
