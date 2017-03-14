//
//  SignUpViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 10/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignUpViewController;

@protocol SignUpViewControllerDelegate
-(void)didSignUp;
@end

@interface SignUpViewController : UIViewController

@property (nonatomic, weak) id<SignUpViewControllerDelegate> SignUpViewControllerDelegate;

- (IBAction)cancelActionButton:(id)sender;
- (IBAction)signUpActionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) NSString *txtEmailString;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) NSString *txtPasswordString;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end
