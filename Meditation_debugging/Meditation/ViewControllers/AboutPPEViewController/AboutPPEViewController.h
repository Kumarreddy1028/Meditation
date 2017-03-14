//
//  AboutPPEViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutPPEViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;
- (IBAction)dashboardBtnActn:(id)sender;

@end
