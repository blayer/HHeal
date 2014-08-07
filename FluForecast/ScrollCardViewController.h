//
//  ScrollCardViewController.h
//  FluForecast
//
//  Created by Changkun Zhao on 8/1/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollCardViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

- (IBAction)cardButton:(id)sender;
@end
