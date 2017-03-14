//
//  DailyHumourViewController.h
//  Meditation
//
//  Created by IOS-2 on 04/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
@interface DailyHumourViewController : UIViewController<JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet UILabel *calendarCurrentDateOnImageLabel;

- (IBAction)calendarBtnActn:(id)sender;
- (IBAction)backBtnActn:(id)sender;
- (IBAction)dashBoardBtnActn:(id)sender;

@end
