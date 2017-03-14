//
//  WeeklyWisdomViewController.h
//  Meditation
//
//  Created by IOS-2 on 11/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
@interface WeeklyWisdomViewController : UIViewController<JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet UILabel *calendarCurrentDateOnImageLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)calendarBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *weeklyTextView;
@property (weak, nonatomic) IBOutlet UIImageView *puzzleLogoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *puzzleView;
@property (nonatomic) CGFloat previousContentoffset;
@property (nonatomic) CGFloat initialContentOffset;

@property (weak, nonatomic) IBOutlet UILabel *puzzleLbl;
- (IBAction)backBtnActn:(id)sender;
- (IBAction)showShareThisWisdomScreenLPGActn:(UILongPressGestureRecognizer *)sender;

@end
