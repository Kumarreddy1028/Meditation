//
//  AlreadySignedInViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 11/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    txtGender, 
    txtLocation
}MLKMenuPopoverTag;

@interface AlreadySignedInViewController : UIViewController

@property (nonatomic, assign) BOOL navigatedToTxtGender;//to know whether user is navigated to txtGender or user has tapped it on his own. If user is navigated to txtGender then he must be navigated to next texfield on dismissing the poover.
@property (weak, nonatomic) IBOutlet UIButton *dashboardBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editBtnWidth;
@property (nonatomic, assign) BOOL navigatedToTxtLocation;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSetImage;
- (IBAction)setImageActionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
- (IBAction)menuActionButton:(id)sender;
- (IBAction)editActionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextView *selfDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionTextCount;
@property (weak, nonatomic) IBOutlet UIImageView *changePasswordImage;
@property (weak, nonatomic) IBOutlet UILabel *bottomSeparatorLbl;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *signOutBtn;
- (IBAction)changePasswordBtnActn:(id)sender;
- (IBAction)dashBoardBtnActn:(id)sender;
- (IBAction)signOutBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editBtnTrailing;
@property (nonatomic, assign) MLKMenuPopoverTag MLKMenuPopoverTag;
@end
