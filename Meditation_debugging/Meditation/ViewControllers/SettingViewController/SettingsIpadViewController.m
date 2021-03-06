//
//  SettingsIpadViewController.m
//  Meditation
//
//  Created by IOS-2 on 14/04/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "SettingsIpadViewController.h"
#import "MLKMenuPopover.h"
#import "Black_Lotus-Swift.h"

@interface SettingsIpadViewController ()<MLKMenuPopoverDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *dayArr;
    NSMutableArray *hourArr;
    NSMutableArray *minuteArr;
    NSMutableArray *beforeAfterArr;
    NSMutableArray *dailyWeeklyArr;
    NSString *finalValue;
    UIPickerView *pickerView;
    UIView * popView;
    UIToolbar *toolBar;
    NSInteger index;
    NSDate *storeDate;
    NSTimer *myTimer;
    NSString *endDateString;
    SevenSwitch *soundSwitch,*vibrateSwitch,*
    setTimeFormatSwitch;
    UIDatePicker *datePicker;
    NSMutableArray *selDateArr;
    NSMutableArray *dateArr;
    NSString *dailyDatePickerStr;
    BOOL is24h;
}

@end

@implementation SettingsIpadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"start_Date"];
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    NSDate *startDate =[df dateFromString:value];
//    df.timeZone = [NSTimeZone systemTimeZone];
//    
//    NSString *timeStr = [df stringFromDate:startDate];
//    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    startDate = [df dateFromString:timeStr];
//    
//    NSString *timeDiffStr = [Utility timeDifference:[NSDate date] ToDate:value];
//    NSArray *arr = [timeDiffStr componentsSeparatedByString:@":"];
//    NSString *dayDiff = [arr objectAtIndex:0];
//    NSString *hourDiff = [arr objectAtIndex:1];
//    
//    if (![dayDiff isEqualToString:@"00"])
//    {
//        self.oneDayBtn.enabled = YES;
//        self.oneDayBtn.alpha = 1.0;
//    }
//    else
//    {
//        self.oneDayBtn.enabled = NO;
//        self.oneDayBtn.alpha = 0.25;
//    }
//    if (![hourDiff isEqualToString:@"00"] || ![dayDiff isEqualToString:@"00"])
//    {
//        self.oneHourBtn.enabled = YES;
//        self.oneHourBtn.alpha = 1.0;
//    }
//    else
//    {
//        self.oneHourBtn.enabled = NO;
//        self.oneHourBtn.alpha = 0.25;
//    }
//
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"start_Date"])
    {
        NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"start_Date"];
  //      if (![value isEqualToString:@"0"])
        {
            self.pinPrickSaveBtn.enabled = YES;
            self.pinPrickSaveBtn.alpha = 1.0;
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            NSDate *startDate =[df dateFromString:value];
            df.timeZone = [NSTimeZone systemTimeZone];
            
            NSString *timeStr = [df stringFromDate:startDate];
            df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            startDate = [df dateFromString:timeStr];
            
            NSString *timeDiffStr = [Utility timeDifference:[NSDate date] ToDate:value];
            NSArray *arr = [timeDiffStr componentsSeparatedByString:@":"];
            NSString *dayDiff = [arr objectAtIndex:0];
            NSString *hourDiff = [arr objectAtIndex:1];
            
            
//            if (![dayDiff isEqualToString:@"00"])
            {
                self.oneDayBtn.enabled = YES;
                self.oneDayBtn.alpha = 1.0;
            }
            self.fifteenMinBtn.enabled = YES;
            self.fifteenMinBtn.alpha=1.0;

//            else
//            {
//                self.oneDayBtn.enabled = NO;
//                self.oneDayBtn.alpha = 0.25;
//            }
            //if (![hourDiff isEqualToString:@"00"] || ![dayDiff isEqualToString:@"00"])
            {
                self.oneHourBtn.enabled = YES;
                self.oneHourBtn.alpha = 1.0;
                self.pinPrickSaveBtn.enabled = YES;
                self.pinPrickSaveBtn.alpha = 1.0;
            }
//            else
//            {
//                self.oneHourBtn.enabled = NO;
//                self.oneHourBtn.alpha = 0.25;
//                self.pinPrickSaveBtn.enabled = NO;
//                self.pinPrickSaveBtn.alpha = 0.25;
//            }
            
        }
//        else
//        {
//            self.oneDayBtn.enabled = NO;
//            self.oneDayBtn.alpha = 0.25;
//            self.oneHourBtn.enabled = NO;
//            self.oneHourBtn.alpha = 0.25;
//            self.pinPrickSaveBtn.enabled = NO;
//            self.pinPrickSaveBtn.alpha = 0.25;
//        }
    }
//    else
//    {
//        self.oneDayBtn.enabled = NO;
//        self.oneDayBtn.alpha = 0.25;
//        self.oneHourBtn.enabled = NO;
//        self.oneHourBtn.alpha = 0.25;
//        self.pinPrickSaveBtn.enabled = NO;
//        self.pinPrickSaveBtn.alpha = 0.25;
//    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selDateArray"])
    {
        selDateArr =[[[NSUserDefaults standardUserDefaults] objectForKey:@"selDateArray"] mutableCopy];
    }
    else
    {
        selDateArr = [[NSMutableArray alloc]initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri", nil];
    }
    if ([selDateArr containsObject:@"Mon"])
    {
        self.monBtn.selected = YES;
    }
    
    if ([selDateArr containsObject:@"Tue"])
    {
        self.tueBtn.selected = YES;
        
    }
    
    if ([selDateArr containsObject:@"Wed"])
    {
        self.wedBtn.selected = YES;
        
    }
    if ([selDateArr containsObject:@"Thu"])
    {
        self.thuBtn.selected = YES;
        
    }
    
    if ([selDateArr containsObject:@"Fri"])
    {
        self.friBtn.selected = YES;
        
    }
    
    if ([selDateArr containsObject:@"Sat"])
    {
        self.satBtn.selected = YES;
        
    }
    if ([selDateArr containsObject:@"Sun"])
    {
        self.sunBtn.selected = YES;
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"datePickerBtnText"])
    {
        [self.dailyDatePickerBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"datePickerBtnText"] forState:UIControlStateNormal];
        dailyDatePickerStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"dailyDatePickerStr"];
    }
    else
    {
        [self.dailyDatePickerBtn setTitle:@"6:00 PM" forState:UIControlStateNormal];
        dailyDatePickerStr = @"18:00";
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"beforePickerBtnText"])
    {
        [self.dailyBeforeTimebtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"beforePickerBtnText"] forState:UIControlStateNormal];
    }
    else
    {
        [self.dailyBeforeTimebtn setTitle:@"15 min" forState:UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dailyAlarm"])
    {
        self.regularMeditationAlarmStatusLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyAlarm"];
    }

    
    NSString *str = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_1day"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_1hour"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_15min"])
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_1day"])
        {
            NSString * value = [[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_1day"];
            if ([value isEqualToString:@"1"])
            {
                //                [self.oneDayBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                self.oneDayBtn.selected = YES;
                str =@"1 day before the event.";
                
            }
            else
            {
                //                [self.oneDayBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
                self.oneDayBtn.selected = NO;
                
            }
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_1hour"])
        {
            NSString * value = [[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_1hour"];
            if ([value isEqualToString:@"1"])
            {
                if ([str isEqualToString:@"1 day before the event."])
                {
                    
                    str =@"1 day and 1 hour before the event.";
                }
                else
                {
                    str =@"1 hour before the event.";
                }
                //                [self.oneHourBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                self.oneHourBtn.selected = YES;
                
            }
            else
            {
                //                [self.oneHourBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
                self.oneHourBtn.selected = NO;
                
                
            }
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_15min"])
        {
            NSString * value = [[NSUserDefaults standardUserDefaults] objectForKey:@"global_meditation_15min"];
            if ([value isEqualToString:@"1"])
            {
                if ([str isEqualToString:@"1 day and 1 hour before the event."])
                {
                    
                    str =@"1 day, 1 hour & 15min before the event.";
                }
                else
                {
                    str =@"1 day and 1 hour before the event.";
                }
                //                [self.oneHourBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
                self.fifteenMinBtn.selected = YES;
                
            }
            else
            {
                //                [self.oneHourBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
                self.fifteenMinBtn.selected = NO;
                
            }
        }
        
    }
    else
    {
        self.oneDayBtn.selected = YES;
        self.oneHourBtn.selected = YES;
        self.fifteenMinBtn.selected = YES;
    }
    self.pinPrickAlarmStatusLabel.text = str;

    self.navigationController.navigationBarHidden = YES;
    self.selectedPinPrickHiddenView.layer.cornerRadius=self.selectedPinPrickHiddenView.frame.size.width/2;
    self.selectedPinPrickHiddenView.layer.masksToBounds=YES;
    self.selectedRegularHiddenView.layer.cornerRadius=self.selectedRegularHiddenView.frame.size.width/2;
    self.selectedRegularHiddenView.layer.masksToBounds=YES;
    self.selectedEventHiddenView.layer.cornerRadius=self.selectedEventHiddenView.frame.size.width/2;
    self.selectedEventHiddenView.layer.masksToBounds=YES;
    self.selectedampmHiddenView.layer.cornerRadius=self.selectedampmHiddenView.frame.size.width/2;
    self.selectedampmHiddenView.layer.masksToBounds=YES;
    
    soundSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.soundView.frame.size.width-100, 25, 80, 35)];
    soundSwitch.onTintColor=[UIColor colorWithRed:154.0/255 green:192.0/255 blue:93.0/255 alpha:1.0];
    soundSwitch.backgroundColor=[UIColor colorWithRed:211.0/255 green:70.0/255 blue:69.0/255 alpha:1.0];
    soundSwitch.layer.cornerRadius = 17.0;
    soundSwitch.on = YES;
    [self.soundView addSubview:soundSwitch];
    [soundSwitch addTarget:self action:@selector(soundSwitchActn:) forControlEvents:UIControlEventValueChanged];
    
    vibrateSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.vibrateView.frame.size.width-100, 25, 80, 35)];
    vibrateSwitch.onTintColor=[UIColor colorWithRed:154.0/255 green:192.0/255 blue:93.0/255 alpha:1.0];
    vibrateSwitch.backgroundColor=[UIColor colorWithRed:211.0/255 green:70.0/255 blue:69.0/255 alpha:1.0];
    vibrateSwitch.layer.cornerRadius = 17.0;
    vibrateSwitch.on = YES;
    [self.vibrateView addSubview:vibrateSwitch];
    [vibrateSwitch addTarget:self action:@selector(viberateSwitchActn:) forControlEvents:UIControlEventValueChanged];
    
    setTimeFormatSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(self.setTimeFormatView.frame.size.width-100, 25, 80, 35)];
    setTimeFormatSwitch.onLabel.text=@"12";
    [setTimeFormatSwitch.onLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];
    [setTimeFormatSwitch.onLabel setTextAlignment:NSTextAlignmentCenter];
    setTimeFormatSwitch.onLabel.textColor=[UIColor blackColor];
    setTimeFormatSwitch.onTintColor=[UIColor colorWithRed:246.0/255 green:225.0/255 blue:136.0/255 alpha:1.0];;
    setTimeFormatSwitch.offLabel.text=@"24";
    [setTimeFormatSwitch.offLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17.0]];

    [setTimeFormatSwitch.offLabel setTextAlignment:NSTextAlignmentCenter];
    
    setTimeFormatSwitch.offLabel.textColor=[UIColor blackColor];
    setTimeFormatSwitch.backgroundColor=[UIColor colorWithRed:158.0/255 green:178.0/255 blue:202.0/255 alpha:1.0];
    setTimeFormatSwitch.layer.cornerRadius = 17.0;
    setTimeFormatSwitch.on = YES;
    [self.setTimeFormatView addSubview:setTimeFormatSwitch];
    [setTimeFormatSwitch addTarget:self action:@selector(setTimeFormatSwitchActn:) forControlEvents:UIControlEventValueChanged];
    
    dayArr=[[NSMutableArray alloc]init];
    for (int i=0; i<=99; i++)
    {
        NSString *str=[NSString stringWithFormat:@"%02d",i];
        [dayArr addObject:str];
        
    }
    
    
    hourArr=[[NSMutableArray alloc]init];
    for (int i=0; i<=23; i++)
    {
        NSString *str=[NSString stringWithFormat:@"%02d",i];
        [hourArr addObject:str];
        
    }
    
    minuteArr=[[NSMutableArray alloc]init];;
    for (int i=0; i<60; i++)
    {
        NSString *str1=[NSString stringWithFormat:@"%02d",i];
        [minuteArr addObject:str1];
    }
    
    self.expandableNotificationView.constant=170;
    self.expandableSetTimeFormatView.constant=0;
    self.expandablSoundView.constant=170;
    beforeAfterArr=[NSMutableArray arrayWithObjects:@"15 min",@"30 min", nil];
//    beforeAfterArr=[NSMutableArray arrayWithObjects:@"before",@"after", nil];
    
    dailyWeeklyArr=[NSMutableArray arrayWithObjects:@"daily",@"weekly", nil];
    
    self.scrollContentView.constant=400;
    
    self.expandablePinPrickView.constant=0;
    self.expendableRegularMeditationsView.constant=0;
    self.expendableEventsView.constant=0;
    self.expendableSetTimeFormatView.constant=0;
    
    self.expandPinPrickButton.layer.borderWidth=1.0f;
    self.expandRegularButton.layer.borderWidth=1.0f;
    self.expandEventButton.layer.borderWidth=1.0f;
    self.expandSetTimeFormatButton.layer.borderWidth=1.0f;
    self.soundView.layer.borderWidth=1.0f;
    self.vibrateView.layer.borderWidth=1.0f;
    self.dailyBeforeTimebtn.layer.borderWidth=2.0;
    self.dailyDatePickerBtn.layer.borderWidth=2.0;
    
    
    self.dailyBeforeTimebtn.layer.borderColor=[UIColor lightGrayColor].CGColor;

    self.dailyDatePickerBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.expandPinPrickButton.layer.borderColor=[UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2].CGColor;
    self.expandRegularButton.layer.borderColor=[UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2].CGColor;
    self.expandEventButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.expandSetTimeFormatButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.soundView.layer.borderColor=[UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2].CGColor;
    self.vibrateView
    .layer.borderColor=[UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:0.2].CGColor;

    self.pinPrickSaveBtn.layer.cornerRadius=10.0;
    self.pinPrickSaveBtn.clipsToBounds=YES;
    
    self.regularMeditationSaveBtn.layer.cornerRadius=10.0;
    self.regularMeditationSaveBtn.clipsToBounds=YES;
    
    self.regularDailyWeeklyBtn.layer.cornerRadius=10.0;
    self.regularDailyWeeklyBtn.clipsToBounds=YES;
    
    self.eventsSaveBtn.layer.cornerRadius=10.0;
    self.eventsSaveBtn.clipsToBounds=YES;
    
    self.pinPrickBeforeAfterBtn.layer.cornerRadius=10.0;
    self.pinPrickBeforeAfterBtn.clipsToBounds=YES;
    
    self.dailyBeforeTimebtn.layer.cornerRadius = 5.0;
    self.dailyDatePickerBtn.layer.cornerRadius = 5.0;
    self.dailyDatePickerBtn.clipsToBounds = YES;
    self.dailyBeforeTimebtn.clipsToBounds = YES;
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
    
    // Do any additional setup after loading the view.
    [self timeFormat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{

//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"])
//    {
//        NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"];
//        if ([value isEqualToString:@"1"])
//        {
//            //            [self.setTimeampmBtn setImage:[UIImage imageNamed:@"am_pm"] forState:UIControlStateNormal];
//            //            [self.setTime24HoursBtn setImage:[UIImage imageNamed:@"immediately"] forState:UIControlStateNormal];
//            //            self.setTimeFormatStatusLabel.text=@"am/pm";
//            [setTimeFormatSwitch setOn:YES animated:NO];
//        }
//        else
//        {
//            //            [self.setTimeampmBtn setImage:[UIImage imageNamed:@"immediately"] forState:UIControlStateNormal];
//            //            [self.setTime24HoursBtn setImage:[UIImage imageNamed:@"am_pm"] forState:UIControlStateNormal];
//            //            self.setTimeFormatStatusLabel.text=@"24 Hours";
//            [setTimeFormatSwitch setOn:NO animated:NO];
//        }
//    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sound"])
    {
        NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"];
        if ([value isEqualToString:@"on"])
        {
            [soundSwitch setOn:YES animated:NO];
        }
        else
        {
            [soundSwitch setOn:NO animated:NO];
            
        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"viberate"])
    {
        NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"viberate"];
        if ([value isEqualToString:@"on"])
        {
            [vibrateSwitch setOn:YES animated:NO];
        }
        else
        {
            [vibrateSwitch setOn:NO animated:NO];
            
        }
    }

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"immediatebtnImage"])
    {
        NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"immediatebtnImage"];
        if ([value isEqualToString:@"1"])
        {
            [self.eventImmediatelyBtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
            self.eventsAlarmStatusLabel.text=@"immediately";
        }
        else
        {
            [self.eventImmediatelyBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
            self.eventsAlarmStatusLabel.text=@"later";
            
        }
        
        
    }
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dailyAlarm"]) {
//        storeDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"store_Date"];
//        self.regularMeditationAlarmStatusLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyAlarm"];
//        self.regularHourLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"regularHourLabel"];
//        self.regularMinuteLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"regularMinuteLabel"];
//        self.regularDailyWeeklyBtn.titleLabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"regularDailyWeeklyBtn"];
//    }
//    
//    if ([storeDate isKindOfClass:[NSNull class]] || storeDate == nil)
//    {
//        
//        storeDate = [NSDate date];
//    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"store_Date"])
//    {
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    endDateString = [dateFormatter stringFromDate:storeDate];
//    
//    NSString *timeDiffStr= [self timeDifference:[NSDate date] ToDate:endDateString];
//    
//    if ([timeDiffStr isEqualToString:@"00:00:00"])
//    {
//        self.pinPrickAlarmStatusLabel.text=[NSString stringWithFormat:@"%@",self.pinPrickBeforeAfterBtn.titleLabel.text];
//        
//    }
//    else
//        self.pinPrickAlarmStatusLabel.text=[NSString stringWithFormat:@"%@ %@",timeDiffStr,self.pinPrickBeforeAfterBtn.titleLabel.text];
//    
//    }
//    
}

-(void)timeFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    NSLog(@"%@\n",(is24h ? @"YES" : @"NO"));
}


- (IBAction)expandButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            

            self.hiddenPinPrickView.hidden=NO;
            self.hiddenRegularMeditationView.hidden=YES;
            self.hiddenEventView.hidden=YES;
            self.hiddenSetTimeFormatView.hidden=YES;
            
            self.pinPrickView.backgroundColor=[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
            self.regularMeditationView.backgroundColor=[UIColor whiteColor];
            self.eventsView.backgroundColor = [UIColor whiteColor];
//            self.selectedampmHiddenView.hidden=YES;
            break;
            
        case 2:

            self.hiddenPinPrickView.hidden=YES;
            self.hiddenRegularMeditationView.hidden=NO;
            self.hiddenEventView.hidden=YES;
            self.hiddenSetTimeFormatView.hidden=YES;
            
            self.pinPrickView.backgroundColor=[UIColor whiteColor];
            self.regularMeditationView.backgroundColor=[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];
            self.eventsView.backgroundColor = [UIColor whiteColor];

            break;
            
        case 3:

            self.hiddenPinPrickView.hidden=YES;
            self.hiddenRegularMeditationView.hidden=YES;
            self.hiddenEventView.hidden=NO;
            self.hiddenSetTimeFormatView.hidden=YES;
            
            self.pinPrickView.backgroundColor=[UIColor whiteColor];
            self.regularMeditationView.backgroundColor=[UIColor whiteColor];
            self.eventsView.backgroundColor = [UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1];

            
            break;
            
        case 4:

            self.hiddenPinPrickView.hidden=YES;
            self.hiddenRegularMeditationView.hidden=YES;
            self.hiddenEventView.hidden=YES;
            self.hiddenSetTimeFormatView.hidden=NO;
            
            
            self.selectedPinPrickHiddenView.hidden=YES;
            self.selectedRegularHiddenView.hidden=YES;
            self.selectedEventHiddenView.hidden=YES;
            self.selectedampmHiddenView.hidden=NO;

            break;
            
        default:
            break;
    }
    
}

- (IBAction)pickerBtnActn:(UIButton *)sender
{
    [UIView setAnimationDuration:0];
    NSArray *dataArray;
    CGFloat height = 120;
    switch (sender.tag)
    {
        case 11:
            beforeAfterArr = dayArr;
            break;
        case 12:
            beforeAfterArr = hourArr;
            break;
        case 13:
            beforeAfterArr = minuteArr;
            break;
        case 14:
            dataArray = beforeAfterArr;
            height = 70;
            break;
        case 15:
            beforeAfterArr = hourArr;
            break;
        case 16:
            beforeAfterArr = minuteArr;
            break;
        case 17:
            beforeAfterArr = dailyWeeklyArr;
            height = 70;
            break;
        case 18:
            beforeAfterArr = dayArr;
            break;
        case 19:
            beforeAfterArr = hourArr;
            break;
        case 20:
            beforeAfterArr = minuteArr;
            break;
    }
    
    if (![popView isDescendantOfView:self.view]) {
        
        CGRect frame1 = [self.view convertRect:sender.frame fromView:sender.superview];
        
        CGRect frame = CGRectMake(frame1.origin.x,frame1.origin.y+frame1.size.height,frame1.size.width +50, height);
        
        popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
        UIView *toolView = [[UIView alloc]initWithFrame:frame];
        
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 ,40,frame.size.width,135)];
        pickerView.delegate = self;
        pickerView.backgroundColor = [UIColor whiteColor];
        toolView.backgroundColor = [UIColor colorWithRed:96.0/255 green:74.0/255 blue:121.0/255 alpha:1.0];
        UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 60,5,50,30)];
        [doneBtn.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:17]];
        [doneBtn setTitle:@"done" forState:UIControlStateNormal];
        doneBtn.titleLabel.textColor = [UIColor blueColor];
        [doneBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:doneBtn];
        [toolView addSubview:pickerView];
        [popView addSubview:toolView];
        [self.view addSubview:popView];
    }
    [pickerView reloadAllComponents];
    index=sender.tag;
}


#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return beforeAfterArr.count;
}

//#pragma mark UIPickerViewDelegate Methods
//
//
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:beforeAfterArr[row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    finalValue=[[NSString alloc]initWithFormat:@"%@",beforeAfterArr[row]];
    // [self.dailyBeforeTimebtn setTitle:finalValue forState:UIControlStateNormal];
    
    switch (index)
    {
        case 11:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",dayArr[selectedIndex]];
            self.pinPrickDayLabel.text=finalValue;
            break;
        case 12:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",hourArr[selectedIndex]];
            self.pinPrickHourLabel.text=finalValue;
            break;
        case 13:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",minuteArr[selectedIndex]];
            self.pinPrickMinuteLabel.text=finalValue;
            break;
        case 14:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",beforeAfterArr[selectedIndex]];
            [self.dailyBeforeTimebtn setTitle:finalValue   forState:UIControlStateNormal];
            break;
            
            
        case 15:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",hourArr[selectedIndex]];
            self.regularHourLabel.text=finalValue;
            break;
        case 16:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",minuteArr[selectedIndex]];
            self.regularMinuteLabel.text=finalValue;
            break;
        case 17:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",dailyWeeklyArr[selectedIndex]];
            [self.regularDailyWeeklyBtn setTitle:finalValue   forState:UIControlStateNormal];
            break;
            
            
        case 18:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",dayArr[selectedIndex]];
            self.eventDayLabel.text=finalValue;
            break;
        case 19:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",hourArr[selectedIndex]];
            self.eventHourLabel.text=finalValue;
            break;
        case 20:
            // finalValue=[[NSString alloc]initWithFormat:@"%@",minuteArr[selectedIndex]];
            self.eventMinuteLabel.text=finalValue;
            break;
    }
}

- (BOOL)arraysContainSameObjects:(NSArray *)array1 andOtherArray:(NSArray *)array2 {
    // quit if array count is different
    if ([array1 count] != [array2 count]) return NO;
    
    BOOL bothArraysContainTheSameObjects = YES;
    
    for (id objectInArray1 in array1) {
        
        if (![array2 containsObject:objectInArray1])
        {
            bothArraysContainTheSameObjects = NO;
            break;
        }
        
    }
    
    return bothArraysContainTheSameObjects;
}

- (IBAction)saveBtnActn:(UIButton *)sender
{
    
    switch (sender.tag)
    {
        case 101:
        {
            NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
            
            for (UILocalNotification *localNotification in arrayOfLocalNotifications)
            {
                
                if ([localNotification.alertBody isEqualToString:@"The Black Lotus global meditation will begin in exact 24 hours from now."])
                {
                    NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                    
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                }
                if ([localNotification.alertBody isEqualToString:@"Let’s meditate together! The Black Lotus global meditation will start in exact 60 minutes from now."])
                {
                    NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                    
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                }
            }

            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"start_Date"])
            {
                NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"start_Date"];
                if (![value isEqualToString:@"0"])
                {
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                NSDate *startDate =[df dateFromString:value];
                df.timeZone = [NSTimeZone systemTimeZone];
                
                NSString *timeStr = [df stringFromDate:startDate];
                df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                startDate = [df dateFromString:timeStr];
                NSString * globalMeditationStatusStr = @"";
                if ([self.oneDayBtn.currentImage isEqual:[UIImage imageNamed:@"select"]])
                {
                    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                    
                    for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                    {
                        
                        if ([localNotification.alertBody isEqualToString:@"The Black Lotus global meditation will begin in exact 24 hours from now."])
                        {
                            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                            
                            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                        }
                        
                    }
                    NSDate *newDate1 = [startDate dateByAddingTimeInterval:-60*60*24];
                    NSString *timeDiffStr = [Utility timeDifference:[NSDate date] ToDate:value];
                    NSArray *arr = [timeDiffStr componentsSeparatedByString:@":"];
                    NSString *diff = [arr objectAtIndex:0];
                    if (![diff isEqualToString:@"00"])
                    {
                        [self.view makeToast:@"Notification preference set."];
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = newDate1;
                        notification.alertBody = @"The Black Lotus global meditation will begin in exact 24 hours from now.";
                        notification.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                        notification.soundName=UILocalNotificationDefaultSoundName;
                        notification.applicationIconBadgeNumber = 1;
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        globalMeditationStatusStr = @"1 day before the event.";
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        [defaults setObject:@"1" forKey:@"global_meditation_1day"];
                        
                        [defaults synchronize];
                        
                    }
                }
                else
                {
                    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                    
                    for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                    {
                        
                        if ([localNotification.alertBody isEqualToString:@"The Black Lotus global meditation will begin in exact 24 hours from now."])
                        {
                            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                            
                            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                        }
                        
                    }
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:@"0" forKey:@"global_meditation_1day"];
                    
                    [defaults synchronize];
                }
                
                if ([self.oneHourBtn.currentImage isEqual:[UIImage imageNamed:@"select"]])
                {
                    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                    
                    for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                    {
                        
                        if ([localNotification.alertBody isEqualToString:@"Let’s meditate together! The Black Lotus global meditation will start in exact 60 minutes from now."])
                        {
                            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                            
                            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                        }
                    }
                    NSDate *newDate1 = [startDate dateByAddingTimeInterval:-60*60*1];
                    NSString *timeDiffStr = [Utility timeDifference:[NSDate date] ToDate:value];
                    NSArray *arr = [timeDiffStr componentsSeparatedByString:@":"];
                    NSString *diff = [arr objectAtIndex:1];
                    NSString *dayDiff = [arr objectAtIndex:0];
                    if (![diff isEqualToString:@"00"] || ![dayDiff isEqualToString:@"00"])
                    {
                        [self.view makeToast:@"Notification preference set."];
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = newDate1;
                        notification.alertBody = @"Let’s meditate together! The Black Lotus global meditation will start in exact 60 minutes from now.";
                        notification.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                        notification.soundName=UILocalNotificationDefaultSoundName;
                        notification.applicationIconBadgeNumber = 1;
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        if ([globalMeditationStatusStr isEqualToString:@"1 day before the event."])
                        {
                            globalMeditationStatusStr = @"1 day and 1 hour before the event.";
                            
                        }
                        else
                        {
                            globalMeditationStatusStr = @"1 hour before the event.";
                            
                        }
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        [defaults setObject:@"1" forKey:@"global_meditation_1hour"];
                        
                        [defaults synchronize];
                   }
                }
                else
                {
                    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                    
                    for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                    {
                        
                        if ([localNotification.alertBody isEqualToString:@"Let’s meditate together! The Black Lotus global meditation will start in exact 60 minutes from now."])
                        {
                            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                            
                            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                        }
                        
                    }
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    [defaults setObject:@"0" forKey:@"global_meditation_1hour"];
                    
                    [defaults synchronize];
                }
                    
                    
                    
                    if ([self.fifteenMinBtn.currentImage isEqual:[UIImage imageNamed:@"select"]])
                    {
                        NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                        
                        for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                        {
                            
                            if ([localNotification.alertBody isEqualToString:@"Let’s meditate together! The Black Lotus global meditation will start in exact 60 minutes from now."])
                            {
                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                
                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                            }
                        }
                        NSDate *newDate1 = [startDate dateByAddingTimeInterval:-15*60*1];
                        NSString *timeDiffStr = [Utility timeDifference:[NSDate date] ToDate:value];
                        NSArray *arr = [timeDiffStr componentsSeparatedByString:@":"];
                        NSString *diff = [arr objectAtIndex:1];
                        NSString *dayDiff = [arr objectAtIndex:0];
                        if (![diff isEqualToString:@"00"] || ![dayDiff isEqualToString:@"00"])
                        {
                            [self.view makeToast:@"Notification preference set."];
                            UILocalNotification *notification = [[UILocalNotification alloc] init];
                            notification.fireDate = newDate1;
                            notification.alertBody = @"Let’s meditate together! The Black Lotus global meditation will start in exact 15 minutes from now.";
                            notification.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                            notification.soundName=UILocalNotificationDefaultSoundName;
                            notification.applicationIconBadgeNumber = 1;
                            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                            if ([globalMeditationStatusStr isEqualToString:@"1 day and 1 hour before the event."])
                            {
                                globalMeditationStatusStr = @"1 day, 1 hour & 15min before the event.";
                                
                            }
                            else
                            {
                                globalMeditationStatusStr = @"1 day and 1 hour before the event.";
                            }
                            
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            
                            //[defaults setObject:@"1" forKey:@"global_meditation_1hour"];
                            [defaults setObject:@"1" forKey:@"global_meditation_15min"];
                            
                            [defaults synchronize];
                        }
                    }
                    else
                    {
                        NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                        
                        for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                        {
                            
                            if ([localNotification.alertBody isEqualToString:@"Let’s meditate together! The Black Lotus global meditation will start in exact 15min minutes from now."])
                            {
                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                
                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                            }
                            
                        }
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        [defaults setObject:@"0" forKey:@"global_meditation_15min"];
                        
                        [defaults synchronize];
                    }
                    
                    
                self.pinPrickAlarmStatusLabel.text = globalMeditationStatusStr;
            
            }
//            else
//            {
//                NSLog(@"%@",value);
//                self.oneDayBtn.enabled = NO;
//                self.oneDayBtn.alpha = 0.25;
//                self.oneHourBtn.enabled = NO;
//                self.oneHourBtn.alpha = 0.25;
//                self.pinPrickSaveBtn.enabled = NO;
//                self.pinPrickSaveBtn.alpha = 0.25;
//            }
        }
//            else
//            {
//                self.oneDayBtn.enabled = NO;
//                self.oneDayBtn.alpha = 0.25;
//                self.oneHourBtn.enabled = NO;
//                self.oneHourBtn.alpha = 0.25;
//                self.pinPrickSaveBtn.enabled = NO;
//                self.pinPrickSaveBtn.alpha = 0.25;
//            }

        }
            break;
            
        case 102:
        {
            NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;

            for (UILocalNotification *localNotification in arrayOfLocalNotifications)
            {

                if ([localNotification.alertBody isEqualToString:[NSString stringWithFormat:@"Meditation time! Be ready for your regular meditation in 15 min."]])
                {
                    NSLog(@"the notification this is canceld is %@", localNotification.alertBody);

                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                }
                if ([localNotification.alertBody isEqualToString:[NSString stringWithFormat:@"Meditation time! Be ready for your regular meditation in 30 min."]])
                {
                    NSLog(@"the notification this is canceld is %@", localNotification.alertBody);

                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                }
            }

            selDateArr = [[NSMutableArray alloc]init];
            for (int i = 1001; i<=1007; i++)
            {
                    UIButton *sender = [self.view viewWithTag:i];
                    switch (sender.tag)
                    {
                        case 1001:
                            if (sender.selected)
                            {
                                [selDateArr addObject:@"Mon"];
                            }
                            break;
                        case 1002:
                            if (sender.selected)
                            {
                                [selDateArr addObject:@"Tue"];
                            }
                            break;
                        case 1003:
                            if (sender.selected)
                            {
                                [selDateArr addObject:@"Wed"];
                            }
                            break;
                        case 1004:
                            if (sender.selected)
                            {
                                [selDateArr addObject:@"Thu"];
                            }
                            
                            break;
                        case 1005:
                            if (sender.selected)
                            {
                                [selDateArr addObject:@"Fri"];
                            }
                            break;
                        case 1006:
                            if (sender.selected)
                            {
                                [selDateArr addObject:@"Sat"];
                            }
                            break;
                        case 1007:
                            if (sender.selected)
                            {
                                [selDateArr addObject:@"Sun"];
                            }
                            break;
                            
                        default:
                            break;
                    }
            }
            
            if ([self.dailyDatePickerBtn titleForState:UIControlStateNormal].length != 0)
            {
                self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekly %@",[self.dailyDatePickerBtn titleForState:UIControlStateNormal]];
                NSDate *todayDate = [NSDate date];
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy/MM/dd"];
                [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                NSString *todayDateStr = [df stringFromDate:todayDate];
                
                todayDate = [df dateFromString:todayDateStr];
                dateArr = [[NSMutableArray alloc]init];
                for (int i=0; i <= 6; i++)
                {
                    int addDaysCount = i;
                    
                    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                    [dateComponents setDay:addDaysCount];
                    
                    // Retrieve date with increased days count
                    NSDate *newDate = [[NSCalendar currentCalendar]
                                       dateByAddingComponents:dateComponents
                                       toDate:todayDate options:0];
                    [dateArr addObject:newDate];
                    
                }
                
                
                for (NSDate *date in dateArr)
                {
                    
                    NSString *timeStr=dailyDatePickerStr;
                    NSArray* timeArr=[timeStr componentsSeparatedByString:@":"];
                    NSDate *newDate1, *selectedTime;
                    selectedTime = [date dateByAddingTimeInterval:60*60*[[timeArr objectAtIndex:0] intValue]+60*[[timeArr objectAtIndex:1] intValue]];
                    if ([[self.dailyBeforeTimebtn titleForState:UIControlStateNormal] isEqualToString:@"15 min"])
                    {
                        newDate1 = [date dateByAddingTimeInterval:60*60*[[timeArr objectAtIndex:0] intValue]+60*[[timeArr objectAtIndex:1] intValue] - 60*15];
                    }
                    else if ([[self.dailyBeforeTimebtn titleForState:UIControlStateNormal] isEqualToString:@"30 min"])
                    {
                        newDate1 = [date dateByAddingTimeInterval:60*60*[[timeArr objectAtIndex:0] intValue]+60*[[timeArr objectAtIndex:1] intValue] - 60*30];
                    }
                    else
                    {
                        newDate1 = [date dateByAddingTimeInterval:60*60*[[timeArr objectAtIndex:0] intValue]+60*[[timeArr objectAtIndex:1] intValue]];
                    }
                    
                    if (!is24h)
                    {
                        [df setDateFormat:@"hh:mm a"];
                    }
                    else
                    {
                        [df setDateFormat:@"HH:mm"];
                    }

                    if ([self arraysContainSameObjects:selDateArr andOtherArray:@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri"]]) {
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekdays at %@",[df stringFromDate:selectedTime]];
                    }
                    else if (selDateArr.count == 7)
                    {
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"daily at %@",[df stringFromDate:selectedTime]];
                    }
                    else if ([self arraysContainSameObjects:selDateArr andOtherArray:@[@"Sat",@"Sun"]])
                    {
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekends at %@",[df stringFromDate:selectedTime]];
                    }
                    else
                    {
                        NSMutableArray *selectedDays = [NSMutableArray new];
                        for (NSString *str in selDateArr) {
                            NSString *firstchar = [str substringToIndex:1];
                            [selectedDays addObject:[firstchar lowercaseString]];
                        }
                        NSString *joinedComponents = [selectedDays componentsJoinedByString:@","];
                        
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"%@ at %@",joinedComponents,[df stringFromDate:selectedTime]];
                        
                    }
                    UILocalNotification *notification;

                    if ([selDateArr containsObject:[self dayFromdate:date]])
                    {
//                        NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
//                        
//                        for (UILocalNotification *localNotification in arrayOfLocalNotifications)
//                        {
//                            
//                            if ([localNotification.alertBody isEqualToString:[NSString stringWithFormat:@"Meditation time! Be ready for your regular meditation in 15 min."]])
//                            {
//                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
//                                
//                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
//                            }
//                            if ([localNotification.alertBody isEqualToString:[NSString stringWithFormat:@"Meditation time! Be ready for your regular meditation in 30 min."]])
//                            {
//                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
//                                
//                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
//                            }
//                            
//                        }
                        
                        notification = [[UILocalNotification alloc] init];
                        notification.fireDate = newDate1;
                        if ([[self.dailyBeforeTimebtn titleForState:UIControlStateNormal] isEqualToString:@"15 min"])
                        {
                     
                            notification.alertBody =[NSString stringWithFormat:@"Meditation time! Be ready for your regular meditation in 15 min."];
                        }
                        else if ([[self.dailyBeforeTimebtn titleForState:UIControlStateNormal] isEqualToString:@"30 min"])
                        {
                    
                            notification.alertBody =[NSString stringWithFormat:@"Meditation time! Be ready for your regular meditation in 30 min."];
                        }
                        notification.repeatInterval = NSCalendarUnitWeekOfYear;
                        
                        notification.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                        notification.soundName=UILocalNotificationDefaultSoundName;
                        
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        
                    }
                }
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:self.regularMeditationAlarmStatusLabel.text forKey:@"dailyAlarm"];
                [defaults setObject:selDateArr forKey:@"selDateArray"];
                [defaults setObject:self.dailyDatePickerBtn.titleLabel.text forKey:@"datePickerBtnText"];
                [defaults setObject:self.dailyBeforeTimebtn.titleLabel.text forKey:@"beforePickerBtnText"];
                [defaults setObject:dailyDatePickerStr forKey:@"dailyDatePickerStr"];

                [defaults synchronize];
            
                [self.view makeToast:@"Notification preference set."];

            }
        }
            break;
        case 103:
        {
            NSString *dayStr =self.eventDayLabel.text;
            int dayValue = [dayStr intValue];
            int daysToAdd = dayValue;
            
            NSString *hourStr=self.eventHourLabel.text;
            int hourValue=[hourStr intValue];
            int hoursToAdd=hourValue;
            
            NSString *minuteStr=self.eventMinuteLabel.text;
            int minuteValue=[minuteStr intValue];
            int minutesToAdd=minuteValue;
            
            NSDate *now = [NSDate date];
            NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd+60*60*hoursToAdd+60*minutesToAdd];
            
            if ([self.eventImmediatelyBtn.currentImage isEqual:[UIImage imageNamed:@"pin_select"]])
            {
                NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                
                for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                {
                    
                    if ([localNotification.alertBody isEqualToString:@"This is Your Immediately notification!"])
                    {
                        NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                        
                        [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                    }
                    
                }
                self.eventsAlarmStatusLabel.text=@"immediately";
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = newDate1;
                notification.alertBody = @"This is Your Immediately notification!";
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName=UILocalNotificationDefaultSoundName;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:@"1" forKey:@"immediatebtnImage"];
                
                [defaults synchronize];
            }
            else
            {
                NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                
                for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                {
                    
                    if ([localNotification.alertBody isEqualToString:@"This is Your Later notification!"])
                    {
                        NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                        
                        [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                        
                    }
                    
                }
                self.eventsAlarmStatusLabel.text=@"later";
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = newDate1;
                notification.alertBody = @"This is Your Later notification!";
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName=UILocalNotificationDefaultSoundName;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:@"0" forKey:@"immediatebtnImage"];
                
                [defaults synchronize];
            }
            [self.view makeToast:@"Your event notification has been set"];

        }
            break;
        case 104:
        {
            if ([self.setTimeampmBtn.currentImage isEqual:[UIImage imageNamed:@"am_pm"]])
            {
                NSString *hourStr=self.regularHourLabel.text;
                int hourValue=[hourStr intValue];
                int hoursToAdd=hourValue;
                NSString *minuteStr=self.regularMinuteLabel.text;
                int minuteValue=[minuteStr intValue];
                int minutesToAdd=minuteValue;
                NSString *dailyWeeklyStr=self.regularDailyWeeklyBtn.titleLabel.text;
                
                if ([dailyWeeklyStr isEqualToString:@"daily"])
                {
                    if (hoursToAdd >= 12)
                    {
                        if (hoursToAdd > 12)
                        {
                            hoursToAdd=hoursToAdd % 12;
                            
                        }
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"daily  %02d:%02d pm",hoursToAdd,minutesToAdd];
                    }
                    else
                    {
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"daily  %02d:%02d am",hoursToAdd,minutesToAdd];
                    }
                }
                if ([dailyWeeklyStr isEqualToString:@"weekly"])
                {
                    
                    if (hoursToAdd >= 12)
                    {
                        if (hoursToAdd > 12)
                        {
                            hoursToAdd=hoursToAdd % 12;
                            
                        }
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekly  %02d:%02d pm",hoursToAdd,minutesToAdd];
                    }
                    else
                    {
                        self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekly  %02d:%02d am",hoursToAdd,minutesToAdd];
                    }
                }
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:@"1" forKey:@"setTimeampm"];
                
                [defaults synchronize];
                
            }
            
            
            if ([self.setTime24HoursBtn.currentImage isEqual:[UIImage imageNamed:@"am_pm"]])
            {
                NSString *hourStr=self.regularHourLabel.text;
                int hourValue=[hourStr intValue];
                int hoursToAdd=hourValue;
                NSString *minuteStr=self.regularMinuteLabel.text;
                int minuteValue=[minuteStr intValue];
                int minutesToAdd=minuteValue;
                NSString *dailyWeeklyStr=self.regularDailyWeeklyBtn.titleLabel.text;
                if ([dailyWeeklyStr isEqualToString:@"daily"])
                {
                    
                    self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"daily  %02d:%02d ",hoursToAdd,minutesToAdd];
                    
                }
                if ([dailyWeeklyStr isEqualToString:@"weekly"])
                {
                    
                    self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekly  %02d:%02d",hoursToAdd,minutesToAdd];
                    
                }
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:@"0" forKey:@"setTimeampm"];
                
                [defaults synchronize];
                
            }
            
        }
            break;
            
    }
    
}

- (IBAction)menuBtnActn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    
}

- (IBAction)eventImmediatelyBtnActn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)setTimeampmBtnActn:(id)sender
{
    [self.setTimeampmBtn setImage:[UIImage imageNamed:@"am_pm"] forState:UIControlStateNormal];
    [self.setTime24HoursBtn setImage:[UIImage imageNamed:@"immediately"] forState:UIControlStateNormal];
    self.setTimeFormatStatusLabel.text=@"am/pm";
    
}

- (IBAction)setTime24HoursBtnActn:(id)sender
{
    [self.setTime24HoursBtn setImage:[UIImage imageNamed:@"am_pm"] forState:UIControlStateNormal];
    [self.setTimeampmBtn setImage:[UIImage imageNamed:@"immediately"] forState:UIControlStateNormal];
    self.setTimeFormatStatusLabel.text=@"24 Hours";
}

- (IBAction)dashboardbtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}

-(NSString *)timeDifference:(NSDate *)fromDate ToDate:(NSString *)toDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:toDate];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *differenceValue = [calendar components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:fromDate toDate:dateFromString options:0];
    NSString *days = [NSString stringWithFormat:@"%02ld",(long)[differenceValue day]];
    NSString *hours = [NSString stringWithFormat:@"%02ld",(long)[differenceValue hour]];
    NSString *minuts = [NSString stringWithFormat:@"%02ld",(long)[differenceValue minute]];
    if ([differenceValue day] < 0 || [differenceValue hour] < 0 || [differenceValue minute] < 0 )
    {
        return @"";
    }
    NSString *remainingTime = [NSString stringWithFormat:@"%@:%@:%@",days,hours,minuts];
    
    return remainingTime;
}

- (IBAction)notificationExpandButtonActn:(id)sender
{
    [UIView beginAnimations:nil context:nil];

    if (self.expandableNotificationView.constant==170)
    {
        [UIView setAnimationDuration:0.25];
        self.expandableNotificationView.constant=0;
       [self.notificationImageView setImage:[UIImage imageNamed:@"expand"]];
        
    }
    else
    {
        [UIView setAnimationDuration:0.25];
        self.expandableNotificationView.constant=170;
        
         [self.notificationImageView setImage:[UIImage imageNamed:@"collapse"]];
     
    }
    self.hiddenPinPrickView.hidden=YES;
    self.hiddenRegularMeditationView.hidden=YES;
    self.hiddenEventView.hidden=YES;
    
    
    self.pinPrickView.backgroundColor = [UIColor whiteColor];
    self.regularMeditationView.backgroundColor = [UIColor whiteColor];
    self.eventsView.backgroundColor = [UIColor whiteColor];


}

- (IBAction)setTimeFormatExpandButtonActn:(id)sender {
    [UIView beginAnimations:nil context:nil];
    
    if (self.expandableSetTimeFormatView.constant==0)
    {
        [UIView setAnimationDuration:0.25];
        self.expandableSetTimeFormatView.constant=0;
            [self.setTimeFormatImageView setImage:[UIImage imageNamed:@"expand"]];
        
    }
    else
    {
        [UIView setAnimationDuration:0.25];
        self.expandableSetTimeFormatView.constant=0;
       
         [self.setTimeFormatImageView setImage:[UIImage imageNamed:@"collapse"]];
        
    }

    self.hiddenSetTimeFormatView.hidden=YES;
    

    self.selectedampmHiddenView.hidden=YES;
}

- (IBAction)soundsExpandBtnActn:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if (self.expandablSoundView.constant==170)
    {
        [UIView setAnimationDuration:0.25];
        self.expandablSoundView.constant=0;
        [self.soundImageView setImage:[UIImage imageNamed:@"expand"]];
        
    }
    else
    {
        [UIView setAnimationDuration:0.25];
        self.expandablSoundView.constant=170;
        
        [self.soundImageView setImage:[UIImage imageNamed:@"collapse"]];
        
    }
    
//    self.hiddenSetTimeFormatView.hidden=YES;
//    
//    
//    self.selectedampmHiddenView.hidden=YES;

}

#pragma  mark- MLKMenuPopover delegate.

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    switch (index)
    {
        case 11:
            finalValue=[[NSString alloc]initWithFormat:@"%@",dayArr[selectedIndex]];
            self.pinPrickDayLabel.text=finalValue;
            break;
        case 12:
            finalValue=[[NSString alloc]initWithFormat:@"%@",hourArr[selectedIndex]];
            self.pinPrickHourLabel.text=finalValue;
            break;
        case 13:
            finalValue=[[NSString alloc]initWithFormat:@"%@",minuteArr[selectedIndex]];
            self.pinPrickMinuteLabel.text=finalValue;
            break;
        case 14:
            finalValue=[[NSString alloc]initWithFormat:@"%@",beforeAfterArr[selectedIndex]];
            [self.pinPrickBeforeAfterBtn setTitle:finalValue   forState:UIControlStateNormal];
            break;
            
            
        case 15:
            finalValue=[[NSString alloc]initWithFormat:@"%@",hourArr[selectedIndex]];
            self.regularHourLabel.text=finalValue;
            break;
        case 16:
            finalValue=[[NSString alloc]initWithFormat:@"%@",minuteArr[selectedIndex]];
            self.regularMinuteLabel.text=finalValue;
            break;
        case 17:
            finalValue=[[NSString alloc]initWithFormat:@"%@",dailyWeeklyArr[selectedIndex]];
            [self.regularDailyWeeklyBtn setTitle:finalValue   forState:UIControlStateNormal];
            break;
            
            
        case 18:
            finalValue=[[NSString alloc]initWithFormat:@"%@",dayArr[selectedIndex]];
            self.eventDayLabel.text=finalValue;
            break;
        case 19:
            finalValue=[[NSString alloc]initWithFormat:@"%@",hourArr[selectedIndex]];
            self.eventHourLabel.text=finalValue;
            break;
        case 20:
            finalValue=[[NSString alloc]initWithFormat:@"%@",minuteArr[selectedIndex]];
            self.eventMinuteLabel.text=finalValue;
            break;
    }
    
}
-(void)didDismissMenuPopover
{
    
}

- (void)viberateSwitchActn:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([sender isOn])
    {
        [defaults setObject:@"on" forKey:@"viberate"];
        
    }
    else
    {
        [defaults setObject:@"off" forKey:@"viberate"];
    }
    [defaults synchronize];
}

- (void)soundSwitchActn:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([sender isOn])
    {
        [defaults setObject:@"on" forKey:@"sound"];
        
    }
    else
    {
        [defaults setObject:@"off" forKey:@"sound"];
    }
    [defaults synchronize];
    
}

- (void)setTimeFormatSwitchActn:(id)sender
{
    if ([sender isOn])
    {
        NSString *hourStr=self.regularHourLabel.text;
        int hourValue=[hourStr intValue];
        int hoursToAdd=hourValue;
        NSString *minuteStr=self.regularMinuteLabel.text;
        int minuteValue=[minuteStr intValue];
        int minutesToAdd=minuteValue;
        NSString *dailyWeeklyStr=self.regularDailyWeeklyBtn.titleLabel.text;
        
        if ([dailyWeeklyStr isEqualToString:@"daily"])
        {
            if (hoursToAdd >= 12)
            {
                if (hoursToAdd > 12)
                {
                    hoursToAdd=hoursToAdd % 12;
                    
                }
                self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"daily  %02d:%02d pm",hoursToAdd,minutesToAdd];
            }
            else
            {
                self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"daily  %02d:%02d am",hoursToAdd,minutesToAdd];
            }
        }
        if ([dailyWeeklyStr isEqualToString:@"weekly"])
        {
            
            if (hoursToAdd >= 12)
            {
                if (hoursToAdd > 12)
                {
                    hoursToAdd=hoursToAdd % 12;
                    
                }
                self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekly  %02d:%02d pm",hoursToAdd,minutesToAdd];
            }
            else
            {
                self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekly  %02d:%02d am",hoursToAdd,minutesToAdd];
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:@"1" forKey:@"setTimeampm"];
        
        [defaults synchronize];
        
    }
    else
    {
        NSString *hourStr=self.regularHourLabel.text;
        int hourValue=[hourStr intValue];
        int hoursToAdd=hourValue;
        NSString *minuteStr=self.regularMinuteLabel.text;
        int minuteValue=[minuteStr intValue];
        int minutesToAdd=minuteValue;
        NSString *dailyWeeklyStr=self.regularDailyWeeklyBtn.titleLabel.text;
        if ([dailyWeeklyStr isEqualToString:@"daily"])
        {
            
            self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"daily  %02d:%02d ",hoursToAdd,minutesToAdd];
            
        }
        if ([dailyWeeklyStr isEqualToString:@"weekly"])
        {
            
            self.regularMeditationAlarmStatusLabel.text=[NSString stringWithFormat:@"weekly  %02d:%02d",hoursToAdd,minutesToAdd];
            
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:@"0" forKey:@"setTimeampm"];
        
        [defaults synchronize];
        
    }
    
}

- (IBAction)dailyDatePickerBtnActn:(UIButton *)sender
{
//    [UIView setAnimationDuration:0];
//    
//    CGRect frame1 = [self.view convertRect:sender.frame fromView:sender.superview];
//    CGRect frame = CGRectMake(frame1.origin.x,frame1.origin.y+frame1.size.height +5,200, 165);
//    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,40,200,135)];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"]) {
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"] isEqualToString:@"1"])
//        {
//            datePicker.datePickerMode=UIDatePickerModeTime;
//        }
//        else
//        {
//            datePicker.datePickerMode=UIDatePickerModeCountDownTimer;
//        }
//    }
//    else
//    {
//        datePicker.datePickerMode=UIDatePickerModeTime;
//        
//    }
//    datePicker.backgroundColor=[UIColor whiteColor];
//    //    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
//    datePicker.hidden=NO;
//    datePicker.date=[NSDate date];
//    popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
//    
//    [datePicker addTarget:self action:@selector(updatedTime:) forControlEvents:UIControlEventValueChanged];
//    //    UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,200,44)];
//    //    toolbar.barStyle = UIBarStyleDefault;
//    //    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    //    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
//    //    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
//    //    [datePicker addSubview:toolbar];
//    UIView *toolView = [[UIView alloc]initWithFrame:frame];
//    toolView.backgroundColor = [UIColor colorWithRed:96.0/255 green:74.0/255 blue:121.0/255 alpha:1.0];
//    UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(150,5,50,30)];
//    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:17]];
//    [doneBtn setTitle:@"done" forState:UIControlStateNormal];
//    doneBtn.titleLabel.textColor = [UIColor blueColor];
//    [doneBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    [toolView addSubview:doneBtn];
//    [toolView addSubview:datePicker];
//    [popView addSubview:toolView];
//    [self.view addSubview:popView];
    
    [UIView setAnimationDuration:0];
    //        CGRect frame1 = [self.view convertRect:sender.frame fromView:sender.superview];
    CGRect frame = CGRectMake(0,0,self.view.frame.size.width, 60);
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0 ,61,self.view.frame.size.width,184)];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"] isEqualToString:@"1"])
        {
            datePicker.datePickerMode=UIDatePickerModeTime;
        }
        else
        {
            datePicker.datePickerMode=UIDatePickerModeCountDownTimer;
        }
    }
    else
    {
        datePicker.datePickerMode=UIDatePickerModeTime;
        
    }
    
    datePicker.backgroundColor=[UIColor whiteColor];
    //    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    datePicker.hidden=NO;
    datePicker.date=[NSDate date];
    popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
    popView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    
    [datePicker addTarget:self action:@selector(updatedTime:) forControlEvents:UIControlEventValueChanged];
    UIView *toolView = [[UIView alloc]initWithFrame:frame];
    toolView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    
    UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -80,10,75,40)];    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:24]];
    [doneBtn setTitle:@"done" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor colorWithRed:96/255.0 green:72/255.0 blue:121/255.0 alpha:1] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200,10,400,40)];
    [titleLbl setTextAlignment:NSTextAlignmentCenter];
    [titleLbl setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:24.0]];
    [titleLbl setText:@"reminder to meditate at"];
    [titleLbl setTextColor:[UIColor colorWithRed:0 green:0 blue:00 alpha:0.69]];
    
    [toolView addSubview:titleLbl];
    [toolView addSubview:doneBtn];
    [popView addSubview:datePicker];
    [popView addSubview:toolView];
    [self.view addSubview:popView];
}

-(void)updatedTime:(id)sender
{
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
//    dateFormat.dateStyle=NSDateFormatterMediumStyle;
// if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"] isEqualToString:@"1"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"setTimeampm"])
// {
//        [dateFormat setDateFormat:@"hh:mm a"];
//        NSString *timeStr=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
//        NSArray* timeArr=[timeStr componentsSeparatedByString:@":"];
//        timeStr = [NSString stringWithFormat:@"%d:%@",[[timeArr objectAtIndex:0] intValue],[timeArr objectAtIndex:1]];
//        [self.dailyDatePickerBtn setTitle:timeStr forState:UIControlStateNormal];
//    }
//    else
//    {
//        [dateFormat setDateFormat:@"HH:mm"];
//        NSString *timeStr=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
//        NSArray* timeArr=[timeStr componentsSeparatedByString:@":"];
//        timeStr = [NSString stringWithFormat:@"%d:%@",[[timeArr objectAtIndex:0] intValue],[timeArr objectAtIndex:1]];
//        [self.dailyDatePickerBtn setTitle:timeStr forState:UIControlStateNormal];
//    }
//    [dateFormat setDateFormat:@"HH:mm"];
//    dailyDatePickerStr=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    //assign text to label
    
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        dateFormat.dateStyle=NSDateFormatterMediumStyle;
     if (!is24h)
     {
            [dateFormat setDateFormat:@"hh:mm a"];
            NSString *timeStr=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
            NSArray* timeArr=[timeStr componentsSeparatedByString:@":"];
            timeStr = [NSString stringWithFormat:@"%d:%@",[[timeArr objectAtIndex:0] intValue],[timeArr objectAtIndex:1]];
            [self.dailyDatePickerBtn setTitle:timeStr forState:UIControlStateNormal];
        }
        else
        {
            [dateFormat setDateFormat:@"HH:mm"];
            NSString *timeStr=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
            NSArray* timeArr=[timeStr componentsSeparatedByString:@":"];
            timeStr = [NSString stringWithFormat:@"%d:%@",[[timeArr objectAtIndex:0] intValue],[timeArr objectAtIndex:1]];
            [self.dailyDatePickerBtn setTitle:timeStr forState:UIControlStateNormal];
        }
        [dateFormat setDateFormat:@"HH:mm"];
        dailyDatePickerStr=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];

}


-(void)backgroundTap
{
//    [datePicker removeFromSuperview];
//    [popView removeFromSuperview];
//    [pickerView removeFromSuperview];
    
}
-(void)dismiss
{
    
    [datePicker removeFromSuperview];
    [popView removeFromSuperview];
    [pickerView removeFromSuperview];
    
}
- (IBAction)dailyBeforeTimeBtnActn:(UIButton *)sender
{
    [UIView setAnimationDuration:0];
//    if (![popView isDescendantOfView:self.view]) {
//        
//    CGRect frame1 = [self.view convertRect:sender.frame fromView:sender.superview];
//    CGRect frame = CGRectMake(frame1.origin.x,frame1.origin.y+frame1.size.height +5,200, 165);
//    
//    popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
//    UIView *toolView = [[UIView alloc]initWithFrame:frame];
//    
//    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 ,40,200,135)];
//    pickerView.delegate = self;
//    pickerView.backgroundColor = [UIColor whiteColor];
//    toolView.backgroundColor = [UIColor colorWithRed:96.0/255 green:74.0/255 blue:121.0/255 alpha:1.0];
//    UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(150,5,50,30)];
//    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:17]];
//    [doneBtn setTitle:@"done" forState:UIControlStateNormal];
//    doneBtn.titleLabel.textColor = [UIColor blueColor];
//    [doneBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    [toolView addSubview:doneBtn];
//    [toolView addSubview:pickerView];
//    [popView addSubview:toolView];
//    [self.view addSubview:popView];
//        
//    }
    if (![popView isDescendantOfView:self.view])
    {
        //        CGRect frame1 = [self.view convertRect:sender.frame fromView:sender.superview];
        CGRect frame = CGRectMake(0,0,self.view.frame.size.width, 60);
        
        popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
        popView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
        UIView *toolView = [[UIView alloc]initWithFrame:frame];
        
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 ,61,self.view.frame.size.width,184)];
        pickerView.delegate = self;
        pickerView.backgroundColor = [UIColor whiteColor];
        toolView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -80,20,75,20)];
        [doneBtn.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:24]];
        [doneBtn setTitle:@"done" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithRed:96/255.0 green:72/255.0 blue:121/255.0 alpha:1] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(5,20,65,20)];
        //        [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15]];
        //        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        //        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200,10,400,40)];
        [titleLbl setTextAlignment:NSTextAlignmentCenter];
        [titleLbl setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:24.0]];
        [titleLbl setText:@"before meditation"];
        [titleLbl setTextColor:[UIColor colorWithRed:0 green:0 blue:00 alpha:0.69]];
        //        [titleLbl setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [toolView addSubview:titleLbl];
        [toolView addSubview:doneBtn];
        //        [toolView addSubview:cancelBtn];
        [popView addSubview:toolView];
        [popView addSubview:pickerView];
        [self.view addSubview:popView];
    }
    index = 14;
    beforeAfterArr = [@[@"15 min",@"30 min"] mutableCopy];
    [pickerView reloadAllComponents];
}

- (IBAction)oneDayBtnActn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;

}

- (IBAction)oneHourBtnActn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}

- (IBAction)fifteenMinBtnActn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}


- (IBAction)dailyBtnActn:(UIButton *)sender
{
    sender.selected = !sender.selected;
//    switch (sender.tag)
//    {
//        case 1001:
//            if (sender.selected)
//            {
//                [selDateArr addObject:@"Mon"];
//            }
//            else
//            {
//                [selDateArr removeObject:@"Mon"];
//            }
//            break;
//        case 1002:
//            if (sender.selected)
//            {
//                [selDateArr addObject:@"Tue"];
//            }
//            else
//            {
//                [selDateArr removeObject:@"Tue"];
//            }
//            break;
//        case 1003:
//            if (sender.selected)
//            {
//                [selDateArr addObject:@"Wed"];
//            }
//            else
//            {
//                [selDateArr removeObject:@"Wed"];
//            }
//            break;
//        case 1004:
//            if (sender.selected)
//            {
//                [selDateArr addObject:@"Thu"];
//            }
//            else
//            {
//                [selDateArr removeObject:@"Thu"];
//            }
//            break;
//        case 1005:
//            if (sender.selected)
//            {
//                [selDateArr addObject:@"Fri"];
//            }
//            else
//            {
//                [selDateArr removeObject:@"Fri"];
//            }
//            break;
//        case 1006:
//            if (sender.selected)
//            {
//                [selDateArr addObject:@"Sat"];
//            }
//            else
//            {
//                [selDateArr removeObject:@"Sat"];
//            }
//            break;
//        case 1007:
//            if (sender.selected)
//            {
//                [selDateArr addObject:@"Sun"];
//            }
//            else
//            {
//                [selDateArr removeObject:@"Sun"];
//            }
//            break;
//            
//        default:
//            break;
//    
//    }
}
-(NSString *)dayFromdate :(NSDate *)day
{
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"EEE"];
    NSString *todayDateStr = [df stringFromDate:day];
    return todayDateStr;
}
- (IBAction)closeBtnActn:(id)sender
{
    self.menuBtn.hidden=NO;
    self.infoBtn.hidden=NO;
    self.dashboardBtn.hidden =NO;
    self.settingsTitle.hidden = NO;
    
    self.closeBtn.hidden=YES;
    self.infoWebView.hidden=YES;
}
- (IBAction)infoBtnActn:(id)sender
{
    self.closeBtn.hidden=NO;
    self.infoWebView.hidden=NO;
    self.menuBtn.hidden=YES;
    self.infoBtn.hidden=YES;
    self.dashboardBtn.hidden = YES;
    self.settingsTitle.hidden = YES;
    [self serviceCallForInfo];
}

-(void)serviceCallForInfo
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    [SVProgressHUD show];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SETTINGS_INFORMATION" forKey:@"REQUEST_TYPE_SENT"];
    
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      { if ([responseObject isKindOfClass:[NSDictionary class]])
      {
          responseObject = [Utility convertDictionaryIntoUTF8:[responseObject allValues] dictionary:responseObject];
      }
          [SVProgressHUD dismissWithDelay:1.0];

          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                  
              }
              else
              {
                  if ([responseObject objectForKey:@"error_code"])
                  {
                      
                  }
                  else if ([responseObject isKindOfClass:[NSDictionary class]])
                  {
                      NSURL *url = [NSURL URLWithString:[responseObject objectForKey:@"info_url"]];
                      [self.infoWebView loadRequest:[NSURLRequest requestWithURL:url]];
                      self.infoWebView.scrollView.bounces = NO;
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}


@end
