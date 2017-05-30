//
//  SettingsViewController.h
//  Meditation
//
//  Created by IOS-2 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SevenSwitch;

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *eventsAlarmStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularMeditationAlarmStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickAlarmStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickMinuteLabel;

@property (weak, nonatomic) IBOutlet UILabel *regularHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularMinuteLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventMinuteLabel;

@property (weak, nonatomic) IBOutlet UIButton *expandPinPrickButton;
@property (weak, nonatomic) IBOutlet UIButton *expandRegularButton;
@property (weak, nonatomic) IBOutlet UIButton *expandEventButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandablePinPrickView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expendableRegularMeditationsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expendableEventsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentView;

@property (weak, nonatomic) IBOutlet UIButton *pinPrickSaveBtn;

@property (weak, nonatomic) IBOutlet UIButton *regularMeditationSaveBtn;

@property (weak, nonatomic) IBOutlet UIButton *eventsSaveBtn;

@property (weak, nonatomic) IBOutlet UIButton *pinPrickBeforeAfterBtn;

@property (weak, nonatomic) IBOutlet UIButton *regularDailyWeeklyBtn;

@property (weak, nonatomic) IBOutlet UIButton *eventImmediatelyBtn;
@property (weak, nonatomic) IBOutlet UIView *soundView;
@property (weak, nonatomic) IBOutlet UIView *setTimeFormatView;

@property (weak, nonatomic) IBOutlet UIView *viberateView;
- (IBAction)expandButtonAction:(UIButton *)sender;
- (IBAction)pickerBtnActn:(UIButton *)sender;
- (IBAction)saveBtnActn:(UIButton *)sender;
- (IBAction)dashboardBtnActn:(id)sender;
- (IBAction)menuBtnActn:(id)sender;
- (IBAction)eventImmediatelyBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dailyDatePickerBtn;
- (IBAction)dailyDatePickerBtnActn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *dailyBeforeTimebtn;
- (IBAction)dailyBeforeTimeBtnActn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *oneDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneHourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifteenMinBtn;


@property (weak, nonatomic) IBOutlet UIButton *monBtn;
@property (weak, nonatomic) IBOutlet UIButton *tueBtn;
@property (weak, nonatomic) IBOutlet UIButton *wedBtn;
@property (weak, nonatomic) IBOutlet UIButton *thurBtn;
@property (weak, nonatomic) IBOutlet UIButton *friBtn;
@property (weak, nonatomic) IBOutlet UIButton *satBtn;
@property (weak, nonatomic) IBOutlet UIButton *sunBtn;
- (IBAction)oneDayBtnActn:(id)sender;
- (IBAction)oneHourBtnActn:(id)sender;
- (IBAction)fifteenMinBtnActn:(id)sender;

- (IBAction)dailyBtnActn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleSettings;
@property (weak, nonatomic) IBOutlet UIButton *dashboardBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (IBAction)infoBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;


@end
