//
//  SocialShareViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 16/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h> 
#import <SpriteKit/SpriteKit.h>

@interface SocialShareViewController : UIViewController

@property BOOL navigated;
@property BOOL isSplit;

@property BOOL isPad;

@property (nonatomic, strong) NSString *titleLabelString;
@property (nonatomic, strong) NSString *textToShare;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

@property (strong, nonatomic) ACAccountStore *accountStore;
- (IBAction)dashboarBtnActn:(id)sender;

@end