//
//  SignInViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 11/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "STTwitter.h"

typedef enum {
    socialPlatformIdFacebook,
    socialPlatformIdTwitter,
    socialPlatformIdGoogle,
} socialPlatformId;

@interface SignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageTopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *containerSubView;
@property (strong, nonatomic) STTwitterAPI * twitter;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UITextField *txtForgetEmail;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)signInActionButton:(id)sender;
- (IBAction)forgetPasswordActionButton:(id)sender;
- (IBAction)createAccountActionButton:(id)sender;
- (IBAction)cancelActionButton:(id)sender;
- (IBAction)submitButtonAction:(id)sender;
- (IBAction)blurViewTapGestureRecogniserAction:(id)sender;

@end
