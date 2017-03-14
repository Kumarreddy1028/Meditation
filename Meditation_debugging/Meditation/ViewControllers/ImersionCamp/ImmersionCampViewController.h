//
//  ImmersionCampViewController.h
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "communityModelClass.h"

@interface ImmersionCampViewController : UIViewController

@property(nonatomic, strong)communityModelClass *event;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UITextView *eventDescTextView;
- (IBAction)backBtnActn:(id)sender;
- (IBAction)registerbtnActn:(id)sender;
- (IBAction)shareBtnAction:(UIButton *)sender;

@end
