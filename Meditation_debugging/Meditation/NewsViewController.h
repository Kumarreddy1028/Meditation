//
//  NewsViewController.h
//  Meditation
//
//  Created by IOS-2 on 02/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
@property (strong, nonatomic) NSString *newsTitleString;
@property (strong, nonatomic) NSString *newsTextViewString;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
- (IBAction)shareBtnActn:(id)sender;
- (IBAction)menuBtnActn:(id)sender;
- (IBAction)dashboardBtnActn:(id)sender;

@end
