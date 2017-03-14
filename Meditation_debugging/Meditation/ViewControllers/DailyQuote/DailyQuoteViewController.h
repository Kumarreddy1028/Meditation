//
//  DailyQuoteViewController.h
//  Meditation
//
//  Created by IOS-2 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
@interface DailyQuoteViewController : UIViewController<JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet UILabel *calendarCurrentDateOnImageLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;

- (IBAction)calenderBtnActn:(id)sender;
- (IBAction)backBtnActn:(id)sender;
- (IBAction)dashboardBtnActn:(id)sender;

@end
