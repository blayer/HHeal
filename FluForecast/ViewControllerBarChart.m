//
//  ViewControllerBarChart.m
//  FluForecast
//
//  Created by Changkun Zhao on 7/21/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import "ViewControllerBarChart.h"
#import "BarChartView.h"


// chartview libs


@interface ViewControllerBarChart ()


@end

@implementation ViewControllerBarChart
@synthesize barChart;

- (void)viewDidLoad {
    //Setup the View Controller
	[super viewDidLoad];
    
    //Load the Bar Chart - you can either load it using an NSArray or an XML File
    [self loadBarChartUsingArray];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)loadBarChartUsingArray {
    //Generate properly formatted data to give to the bar chart
    NSArray *array = [barChart createChartDataWithTitles:[NSArray arrayWithObjects:@"Title 1", @"Title 2", @"Title 3", @"Title 4", nil]
                                                  values:[NSArray arrayWithObjects:@"4.7", @"8.3", @"17", @"5.4", nil]
                                                  colors:[NSArray arrayWithObjects:@"87E317", @"17A9E3", @"E32F17", @"FFE53D", nil]
                                             labelColors:[NSArray arrayWithObjects:@"FFFFFF", @"FFFFFF", @"FFFFFF", @"FFFFFF", nil]];
    //Set the Shape of the Bars (Rounded or Squared) - Rounded is default
    [barChart setupBarViewShape:BarShapeRounded];
    
    //Set the Style of the Bars (Glossy, Matte, or Flat) - Glossy is default
    [barChart setupBarViewStyle:BarStyleGlossy];
    
    //Set the Drop Shadow of the Bars (Light, Heavy, or None) - Light is default
    [barChart setupBarViewShadow:BarShadowLight];
    
    //Generate the bar chart using the formatted data
    [barChart setDataWithArray:array
                      showAxis:DisplayBothAxes
                     withColor:[UIColor whiteColor]
       shouldPlotVerticalLines:YES];
}





#pragma mark - View Lifecycle






@end
