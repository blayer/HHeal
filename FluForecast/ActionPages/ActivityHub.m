//
//  ActivityHub.m
//  HHeal
//
//  Created by Changkun Zhao on 10/6/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ActivityHub.h"

@implementation ActivityHub

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.0;
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.frame = CGRectMake(80, 80,10,10);
        [self addSubview:self.activityView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.label];
        self.figure=[[UIImageView alloc]initWithFrame:CGRectMake(55, 30, 60.0, 60.0)];
        [self addSubview:self.figure];
    }
    
    return self;
    
}


-(void) setImage: (UIImage*)image{
    self.figure.image=image;
}

-(void) setLabelText:(NSString*) text{
    
    self.label.text=text;
}

-(void) showActivityView{
    [self.activityView startAnimating];
    
}

-(void) dismissActivityView{
    
    [self.activityView stopAnimating];
}

@end
