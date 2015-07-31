//
//  NSObject_HHealParameter.h
//  FluForecast
//
//  Created by Changkun Zhao on 8/21/14.
//  Copyright (c) 2014 Changkun Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define HHealURL      @"http://localhost:3000"
// for official app
#define HHealURL        @"http://ec2-54-68-139-241.us-west-2.compute.amazonaws.com"
//for test
//#define HHealURL        @"http://ec2-54-84-82-23.compute-1.amazonaws.com"
#define GetTrainingCard @"/trainingcard/"
#define UserProfile     @"/user_profile/"
#define Login           @"/login/"
#define GetUserAllCards @"/user_trainingcard/"
#define ReportFlu       @"/flureport/"
#define GetTrainingLogs @"/trainingcardhistory/"
#define GetRiskLogs     @"/user_fluforecast/"
#define Ebola           @"/ebola"




@interface NSObject ()

@end
