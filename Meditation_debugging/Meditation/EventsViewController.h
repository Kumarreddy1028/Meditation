//
//  EventsViewController.h
//  Meditation
//
//  Created by IOS-2 on 02/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController
@property (strong, nonatomic) NSString *eventTitleString;
@property (strong, nonatomic) NSString *eventTextViewString;
@property (strong, nonatomic) NSString *bookBtnUrlString;
@property (strong, nonatomic) NSString *startDateString;
@property (strong, nonatomic) NSString *endDateString;

@property (weak, nonatomic) IBOutlet UITextView *eventsTextView;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
- (IBAction)bookBtnActn:(id)sender;
- (IBAction)shareBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLbl;


- (IBAction)menuBtnActn:(id)sender;
- (IBAction)dashboardBtnActn:(id)sender;

@end
