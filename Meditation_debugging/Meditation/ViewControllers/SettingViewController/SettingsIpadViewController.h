//
//  SettingsIpadViewController.h
//  Meditation
//
//  Created by IOS-2 on 14/04/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SevenSwitch;

@interface SettingsIpadViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *setTimeFormatStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventsAlarmStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularMeditationAlarmStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickAlarmStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinPrickMinuteLabel;
@property (weak, nonatomic) IBOutlet UIView *pinPrickView;
@property (weak, nonatomic) IBOutlet UIView *regularMeditationView;
@property (weak, nonatomic) IBOutlet UIView *eventsView;

@property (weak, nonatomic) IBOutlet UILabel *regularHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularMinuteLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventMinuteLabel;
- (IBAction)notificationExpandButtonActn:(id)sender;
- (IBAction)setTimeFormatExpandButtonActn:(id)sender;
- (IBAction)soundsExpandBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *expandPinPrickButton;
@property (weak, nonatomic) IBOutlet UIButton *expandRegularButton;
@property (weak, nonatomic) IBOutlet UIButton *expandEventButton;
@property (weak, nonatomic) IBOutlet UIButton *expandSetTimeFormatButton;
@property (weak, nonatomic) IBOutlet UIView *hiddenPinPrickView;
@property (weak, nonatomic) IBOutlet UIView *hiddenRegularMeditationView;
@property (weak, nonatomic) IBOutlet UIView *hiddenEventView;
@property (weak, nonatomic) IBOutlet UIView *hiddenSetTimeFormatView;
@property (weak, nonatomic) IBOutlet UIView *selectedPinPrickHiddenView;
@property (weak, nonatomic) IBOutlet UIView *selectedRegularHiddenView;
@property (weak, nonatomic) IBOutlet UIView *selectedEventHiddenView;
@property (weak, nonatomic) IBOutlet UIView *selectedampmHiddenView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandableNotificationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandableSetTimeFormatView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandablSoundView;

@property (weak, nonatomic) IBOutlet UIView *soundView;

@property (weak, nonatomic) IBOutlet UIView *vibrateView;

@property (weak, nonatomic) IBOutlet UIView *setTimeFormatView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandablePinPrickView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expendableRegularMeditationsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expendableEventsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expendableSetTimeFormatView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentView;

@property (weak, nonatomic) IBOutlet UIButton *pinPrickSaveBtn;

@property (weak, nonatomic) IBOutlet UIButton *regularMeditationSaveBtn;

@property (weak, nonatomic) IBOutlet UIButton *eventsSaveBtn;

@property (weak, nonatomic) IBOutlet UIButton *setTimeFormatSaveBtn;

@property (weak, nonatomic) IBOutlet UIButton *pinPrickBeforeAfterBtn;

@property (weak, nonatomic) IBOutlet UIButton *regularDailyWeeklyBtn;

@property (weak, nonatomic) IBOutlet UIButton *setTimeampmBtn;

@property (weak, nonatomic) IBOutlet UIButton *setTime24HoursBtn;

@property (weak, nonatomic) IBOutlet UIButton *eventImmediatelyBtn;

- (IBAction)expandButtonAction:(UIButton *)sender;


- (IBAction)pickerBtnActn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;

@property (weak, nonatomic) IBOutlet UIImageView *setTimeFormatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *soundImageView;

- (IBAction)saveBtnActn:(UIButton *)sender;

- (IBAction)menuBtnActn:(id)sender;


- (IBAction)eventImmediatelyBtnActn:(id)sender;
- (IBAction)setTimeampmBtnActn:(id)sender;
- (IBAction)setTime24HoursBtnActn:(id)sender;
- (IBAction)dashboardbtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *oneDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneHourBtn;
- (IBAction)oneDayBtnActn:(id)sender;
- (IBAction)oneHourBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *settingsTitle;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *dashboardBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (IBAction)closeBtnActn:(id)sender;
- (IBAction)infoBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

- (IBAction)dailyBtnActn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *monBtn;
@property (weak, nonatomic) IBOutlet UIButton *tueBtn;
@property (weak, nonatomic) IBOutlet UIButton *wedBtn;
@property (weak, nonatomic) IBOutlet UIButton *thuBtn;
@property (weak, nonatomic) IBOutlet UIButton *friBtn;
@property (weak, nonatomic) IBOutlet UIButton *satBtn;
@property (weak, nonatomic) IBOutlet UIButton *sunBtn;

@property (weak, nonatomic) IBOutlet UIButton *dailyDatePickerBtn;
- (IBAction)dailyDatePickerBtnActn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *dailyBeforeTimebtn;
- (IBAction)dailyBeforeTimeBtnActn:(UIButton *)sender;
@end
