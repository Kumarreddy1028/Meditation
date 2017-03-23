//  AlreadySignedInViewController.m
//  Meditation
//  Created by IOS1-2016 on 11/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//
#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define AUDIO_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"MyAudioMemo.m4a\"\r\nContent-Type: audio/m4a\r\n\r\n"

#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"

#define MAX_TEXT_LIMIT_FOR_DESCRIPTION 500
#define self_Description_Placeholder_Text @"Description"
#define GoogleAPIKey @"AIzaSyB933rtM3bxLpV6k5YL4l-hWgPpfgstRX8"

#import "AlreadySignedInViewController.h"
#import "MLKMenuPopover.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "ChangePasswordViewController.h"
#import "RecentSearchListViewController.h"
#import "TOCropViewController.h"
#import "SignInViewController.h"

@interface AlreadySignedInViewController ()<UITextFieldDelegate ,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MLKMenuPopoverDelegate, RecentSearchDelegate, TOCropViewControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *arrGender, *googleSearchPlaces;
    NSMutableArray *arrCountries;
    NSData *imageToUpload;
    RecentSearchListViewController *controller;
    UIView * popView;
    UIPickerView *contentPickerView;
    NSString *locationName;
    __weak IBOutlet UILabel *_descriptionCharCountLabel;
}

@end
@implementation AlreadySignedInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  [[self.txtLocation valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    [[self.txtGender valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    arrCountries = [[NSMutableArray alloc]init];
    
    controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RecentSearchListViewController class])];
    if ([Utility sharedInstance].isDeviceIpad )
    {
        CGFloat height = self.view.frame.size.height/2;
        controller.view.frame = CGRectMake(self.txtLocation.frame.origin.x, self.txtLocation.frame.origin.y + self.txtLocation.frame.size.height +100, self.txtLocation.frame.size.width, height);
    }
    else
    {
        CGFloat height = self.view.frame.size.height/2;
        controller.view.frame = CGRectMake(self.txtLocation.frame.origin.x, self.txtLocation.frame.origin.y + self.txtLocation.frame.size.height +50, self.txtLocation.frame.size.width, height);
    }
    controller.delegate = self;
    
    //[self callServiceGetCountries];
    [self callServiceGetProfile];
    arrGender = [[NSArray alloc]initWithObjects:@"Male",@"Female",@"Other", nil];
    self.selfDescriptionTextView.delegate = self;
    self.btnSetImage.layer.cornerRadius = (self.btnSetImage.frame.size.width/2);
    self.btnSetImage.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
//    [self.selfDescriptionTextView setFont:[UIFont systemFontOfSize:15.0]];
    
    self.txtUserName.attributedPlaceholder = [Utility placeholder:@"name"];
    self.txtPassword.attributedPlaceholder = [Utility placeholder:@"password"];
    self.txtLocation.attributedPlaceholder = [Utility placeholder:@"location"];
    self.txtGender.attributedPlaceholder = [Utility placeholder:@"gender"];
    self.txtEmail.attributedPlaceholder = [Utility placeholder:@"email address"];
//    self.txtUserName.textColor = [UIColor lightGrayColor];
//    self.txtPassword.textColor = [UIColor lightTextColor];
//    self.txtLocation.textColor = [UIColor lightTextColor];
//    self.txtGender.textColor = [UIColor lightTextColor];
//    self.txtEmail.textColor = [UIColor lightTextColor];
//    NSString *imageUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"profileImageUrl"];
//    
//    NSData *imageData = [NSData dataWithContentsOfFile:imageUrl];
//    if (imageData) {
//        [self.btnSetImage setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
//    }
    
    if ([[Utility sharedInstance] profileImage]) {
        [self.btnSetImage setBackgroundImage:[[Utility sharedInstance] profileImage] forState:UIControlStateNormal];
    }
    
    [self setEditable:FALSE];
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    [toolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    [self.selfDescriptionTextView setInputAccessoryView:toolbar];
    
    if ([Utility sharedInstance].country.length == 0 || [Utility sharedInstance].country == nil) {
        [[Utility sharedInstance] getCurrentLocationAndRegisterDeviceToken];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.signOutBtn.frame = self.changePasswordBtn.frame;
}

-(void)resignKeyboard
{
    [self.selfDescriptionTextView resignFirstResponder];
}
- (IBAction)menuActionButton:(id)sender
{
    UIImage *currentImage = [sender imageForState:UIControlStateNormal];
    UIImage *menuImage = [UIImage imageNamed:@"menu"];
    UIImage *editImage = [UIImage imageNamed:@"edit"];
    if ([self image:currentImage isEqualTo:menuImage])
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    else
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to discard changes ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *discardAction = [UIAlertAction actionWithTitle:@"Discard" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       self.txtUserName.text = [self.txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                       self.changePasswordImage.hidden=YES;
                                       self.changePasswordBtn.hidden=YES;
                                       self.bottomSeparatorLbl.hidden=YES;
                                       self.dashboardBtn.hidden=NO;
                                       self.signOutBtn.hidden=NO;

                                       if ([Utility sharedInstance].isDeviceIpad )
                                       {
                                           self.editBtnWidth.constant = 55;
                                           self.editBtnTrailing.constant = 90;
                                           
                                       }
                                       else
                                       {
                                           self.editBtnWidth.constant = 33;
                                           self.editBtnTrailing.constant = 53;
                                           
                                       }
                                       [self setEditable:FALSE];

                                       [self.btnEdit setImage:editImage forState:UIControlStateNormal];
                                       [self.menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
                                       self.txtLocation.userInteractionEnabled = NO;
                                       self.txtGender.userInteractionEnabled = NO;
                                       self.txtEmail.userInteractionEnabled = NO;
                                       self.txtPassword.userInteractionEnabled = NO;
                                       self.selfDescriptionTextView.editable = NO;
                                       self.txtUserName.userInteractionEnabled = NO;
                                       [self.txtLocation becomeFirstResponder];
                                       [self callServiceGetProfile];
//                                       [self.menuButton setImage:menuImage forState:UIControlStateNormal];
//                                       [self.btnEdit setImage:editImage forState:UIControlStateNormal];
//                                       if ([Utility sharedInstance].isDeviceIpad )
//                                       {
//                                           self.editBtnWidth.constant = 55;
//                                       }
//                                       else
//                                       {
//                                           self.editBtnWidth.constant = 33;
//                                       }
//                                       self.txtLocation.userInteractionEnabled = NO;
//                                       self.txtGender.userInteractionEnabled = NO;
//                                       self.txtEmail.userInteractionEnabled = NO;
//                                       self.txtPassword.userInteractionEnabled = NO;
//                                       self.selfDescriptionTextView.editable = NO;
//                                       self.txtUserName.userInteractionEnabled = NO;
//                                       [self.txtLocation becomeFirstResponder];
//                                       [self callServiceGetProfile];
//                                       self.selfDescriptionTextView.editable = YES;

//                                       self.selfDescriptionTextView.editable = NO;


                                   }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    [myAlert addAction:discardAction];
    [myAlert addAction:cancelAction];
    [self presentViewController:myAlert animated:YES completion:nil];
    }
}


-(void) setEditable:(BOOL)editable {
    UIColor *color = [UIColor lightTextColor];
    [self.selfDescriptionTextView setEditable:TRUE];
    [self.selfDescriptionTextView setUserInteractionEnabled:TRUE];
    if (editable) {
        color = [UIColor whiteColor];
    }
    self.txtUserName.textColor = color;
    self.txtPassword.textColor = color;
    self.txtLocation.textColor = color;
    self.txtGender.textColor = color;
    self.txtEmail.textColor = [UIColor lightTextColor];
    self.selfDescriptionTextView.textColor = color;

    [self.selfDescriptionTextView setEditable:editable];
    [self.selfDescriptionTextView setUserInteractionEnabled:editable];
}

- (IBAction)editActionButton:(id)sender
{
    UIImage *currentImage = [sender imageForState:UIControlStateNormal];
    UIImage *editImage = [UIImage imageNamed:@"edit"];
    UIImage *correctImage = [self updateImageNamed:@"check" withColor:[UIColor whiteColor]];
    [self setEditable:TRUE];
   
    if ([self image:currentImage isEqualTo:editImage])
    {
        self.dashboardBtn.hidden = YES;
        self.changePasswordImage.hidden=NO;
        self.changePasswordBtn.hidden=NO;
        self.bottomSeparatorLbl.hidden=NO;
        self.signOutBtn.hidden=YES;
        [self.btnEdit setImage:correctImage forState:UIControlStateNormal];
//        [self.btnEdit setTitle:@"save" forState:UIControlStateNormal];
        [self.btnEdit.titleLabel setTextAlignment:NSTextAlignmentRight];
        if ([Utility sharedInstance].isDeviceIpad )
        {
            self.editBtnWidth.constant = 90;
            self.editBtnTrailing.constant = 15;

        }
        else
        {
            self.editBtnWidth.constant = 45;
            self.editBtnTrailing.constant = 10;

        }
        [self.menuButton setImage:[UIImage imageNamed:@"books_cross"] forState:UIControlStateNormal];
        self.txtLocation.userInteractionEnabled = YES;
        self.txtGender.userInteractionEnabled = YES;
        self.selfDescriptionTextView.editable = YES;
        self.txtUserName.userInteractionEnabled = YES;
        
    }
//    else if ([self image:currentImage isEqualTo:correctImage])
    else
    {
//        if ([Utility isEmpty:self.txtUserName.text])
//        {
//            UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"please enter Name" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//            [myAlert addAction:action];
//            [self presentViewController:myAlert animated:YES completion:nil];
//            return;
//        }
       self.txtUserName.text = [self.txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.changePasswordImage.hidden=YES;
        self.changePasswordBtn.hidden=YES;
        self.bottomSeparatorLbl.hidden=YES;
        self.dashboardBtn.hidden=NO;
        self.signOutBtn.hidden=NO;
        if ([Utility sharedInstance].isDeviceIpad )
        {
            self.editBtnWidth.constant = 55;
            self.editBtnTrailing.constant = 90;

        }
        else
        {
            self.editBtnWidth.constant = 33;
            self.editBtnTrailing.constant = 53;

        }
        [self.btnEdit setImage:editImage forState:UIControlStateNormal];
        [self.menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        self.txtLocation.userInteractionEnabled = NO;
        self.txtGender.userInteractionEnabled = NO;
        self.txtEmail.userInteractionEnabled = NO;
        self.txtPassword.userInteractionEnabled = NO;
        self.selfDescriptionTextView.editable = NO;
        self.txtUserName.userInteractionEnabled = NO;
        [self.txtLocation becomeFirstResponder];
        [self callServiceUpdateProfile];
    }

}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

- (IBAction)setImageActionButton:(id)sender
{
if (![self.btnEdit.currentImage isEqual:[UIImage imageNamed:@"edit"]])          {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Set Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                {
                                }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                                    picker.delegate = self;
                                   // picker.allowsEditing = YES;
                                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                    [self presentViewController:picker animated:YES completion:nil];
                                    
                                }]];
      
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                    {
                                        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                                        picker.delegate = self;
                                       // picker.allowsEditing = YES;
                                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        [self presentViewController:picker animated:YES completion:nil];
                                    }
                                    else
                                    {
                                        UIAlertController *myAlertView = [UIAlertController alertControllerWithTitle:@"Hardware Error" message:@"Your Device Doesn't support Camera" preferredStyle:UIAlertControllerStyleAlert];
                                        //creating alertController.
                                        [self presentViewController:myAlertView animated:YES completion:nil];
                                        //presenting alertViewController.
                                        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                            [myAlertView dismissViewControllerAnimated:YES completion:nil];//creating cancelButton
                                        }];
                                        
                                        [myAlertView addAction:cancelButton];//addingCancelButton to UIAlertController.
                                    }
                                    
                                }]];
        if ([Utility sharedInstance].isDeviceIpad )
        {
            actionSheet.popoverPresentationController.sourceView = self.view;
            actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.frame.size.width/2, self.btnSetImage.frame.origin.y + 350, 1.0, 1.0);
            [actionSheet.popoverPresentationController setPermittedArrowDirections:UIPopoverArrowDirectionUp];
        }
     
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    
}

#pragma mark - textField delegate methods.
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
//    if (textField == self.txtLocation)
//    {
//        [popView removeFromSuperview];
//        [contentPickerView removeFromSuperview];
//        self.txtLocation.text = locationName;
//    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtGender)
    {
        [self.txtUserName resignFirstResponder];
        [self.txtLocation resignFirstResponder];
        [self.selfDescriptionTextView resignFirstResponder];
        
        if (![popView isDescendantOfView:self.view])
        {
            //        CGRect frame1 = [self.view convertRect:sender.frame fromView:sender.superview];
            CGRect frame = CGRectMake(0,0,self.view.frame.size.width, 60);
            
            popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
            popView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
            UIView *toolView = [[UIView alloc]initWithFrame:frame];
            
            contentPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 ,61,self.view.frame.size.width,184)];
            contentPickerView.delegate = self;
            contentPickerView.tag = 101;
            contentPickerView.backgroundColor = [UIColor whiteColor];
            toolView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
            UIButton *doneBtn;
            //        UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(5,20,65,20)];
            //        [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"santana" size:15]];
            //        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            //        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            //        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            UILabel *titleLbl;
            if ([Utility sharedInstance].isDeviceIpad )
            {
                titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200,10,400,40)];
                
                [titleLbl setFont:[UIFont fontWithName:@"santana-Bold" size:24.0]];
                 doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -80,10,75,40)];
                [doneBtn.titleLabel setFont:[UIFont fontWithName:@"santana-Bold" size:24]];

            }
            else
            {
                titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100,20,200,20)];

                [titleLbl setFont:[UIFont fontWithName:@"santana-Bold" size:15.0]];
                 doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -50,20,45,20)];
                [doneBtn.titleLabel setFont:[UIFont fontWithName:@"santana-Bold" size:15]];

            }
            [doneBtn setTitle:@"done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor colorWithRed:96/255.0 green:72/255.0 blue:121/255.0 alpha:1] forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(dismissGender) forControlEvents:UIControlEventTouchUpInside];
            [titleLbl setTextAlignment:NSTextAlignmentCenter];

            [titleLbl setText:@"gender"];
            [titleLbl setTextColor:[UIColor colorWithRed:0 green:0 blue:00 alpha:0.69]];
            //        [titleLbl setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [toolView addSubview:titleLbl];
            [toolView addSubview:doneBtn];
            //        [toolView addSubview:cancelBtn];
            [popView addSubview:toolView];
            [popView addSubview:contentPickerView];
            [self.view addSubview:popView];
        }
        [contentPickerView reloadAllComponents];

        
        [textField resignFirstResponder];
        return NO;
    }
    else if ([textField isEqual:self.txtLocation])
    {
        if ([Utility sharedInstance].state || [Utility sharedInstance].country) {
            [self.txtLocation setText:[NSString stringWithFormat:@"%@, %@", [Utility sharedInstance].state, [Utility sharedInstance].country]];
        }
        [self.txtUserName resignFirstResponder];
        [self.selfDescriptionTextView resignFirstResponder];
    }
    return YES;
}

- (void)dismissGender
{
    [popView removeFromSuperview];
    [contentPickerView removeFromSuperview];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
////    if (textField == self.txtLocation) {
////        if (textField.text.length >= 2 && range.length == 0)
////        {
////            NSString *str = [textField.text stringByAppendingString:string];
////            [self getAutomaticPlacesReturnedByGoogleAPI:str];
////          //  [textField resignFirstResponder];
////            return YES;
////        }
////        else
////        {
////            return YES;
////        }
////    }
////    else
////    {
////        return YES;
////    }
//    return YES;
//}


#pragma mark - MLKMenuPopover delegate methods.

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [menuPopover dismissMenuPopover];
    if (self.MLKMenuPopoverTag == txtGender)
    {
        self.txtGender.text = [arrGender objectAtIndex:selectedIndex];
    }
//    else if(self.MLKMenuPopoverTag == txtLocation)
//    {
//        NSDictionary *selectedCountry =[arrCountries objectAtIndex:selectedIndex];
//        self.txtLocation.text = [selectedCountry objectForKey:@"name"];
//        NSString *countryId = [selectedCountry objectForKey:@"country_id"];
//        [[NSUserDefaults standardUserDefaults] setObject:countryId forKey:@"country_id"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
}
-(void) didDismissMenuPopover
{
    //checking if the user was navigated or not.
    if (self.navigatedToTxtGender)
    {
        //if navigated to txtGender then navigate to next textfield.
        [self textFieldShouldReturn:self.txtGender];
        self.navigatedToTxtGender = NO;
    }
    else if (self.navigatedToTxtLocation)
    {
        //if navigated to txtLocation then navigate to next textfield.
        [self textFieldShouldReturn:self.txtLocation];
        self.navigatedToTxtLocation = NO;
    }
}

#pragma mark - textView delegate methods.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    long textCount = [self whiteSpaceTrimmedLength:textView.text] - range.length;
//    BOOL textLimitReached = textCount >= MAX_TEXT_LIMIT_FOR_DESCRIPTION;
    long updatedTextCount = textCount + [self whiteSpaceTrimmedLength:text];
    BOOL textLimitReached = updatedTextCount > MAX_TEXT_LIMIT_FOR_DESCRIPTION;
    if (textLimitReached)
    {
        NSString *message = [NSString stringWithFormat:@"Description"];
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Text limit reached" message:@"Please limit your description to 500 characters." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [myAlert addAction:action];
                    [self presentViewController:myAlert animated:YES completion:nil];

    }
    //[_descriptionCharCountLabel setText:[NSString stringWithFormat:@"%ld/%d", textView.text.length, MAX_TEXT_LIMIT_FOR_DESCRIPTION]];
    return (!textLimitReached);
}

-(long)whiteSpaceTrimmedLength:(NSString *)text
{
    NSString *trimmedText = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
   trimmedText = [trimmedText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return trimmedText.length;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self_Description_Placeholder_Text])
    {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self_Description_Placeholder_Text;
        textView.textColor = [UIColor lightGrayColor];
    }
    self.lblDescriptionTextCount.text = @"";
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    long textCount = [self whiteSpaceTrimmedLength:textView.text];
    self.lblDescriptionTextCount.text = [NSString stringWithFormat:@"%ld/%d",textCount,MAX_TEXT_LIMIT_FOR_DESCRIPTION];
}

#pragma mark - imagePickerController delegate methods.

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *choosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self presentCropViewController:choosenImage];
   // [self uploadImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentCropViewController:(UIImage *)image
{
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
    cropViewController.delegate = self;
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    imageToUpload = UIImagePNGRepresentation(image);
     [self uploadImage];
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    // 'image' is the newly cropped, circular version of the original image
}

- (void)getAutomaticPlacesReturnedByGoogleAPI:(NSString *)loc
{
    NSString *esc_addr =  [loc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@,%@&location=37.76999,-122.44696&radius=500&sensor=true&key=%@",esc_addr,[Utility sharedInstance].country, GoogleAPIKey];
    
    NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:req]];
    
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *places = [NSMutableArray new];
    for (NSDictionary *dict in [resultDict objectForKey:@"predictions"]) {
        [places addObject:[dict objectForKey:@"description"]];
    }
    googleSearchPlaces = places;
    
    if (![popView isDescendantOfView:self.view])
    {
        //        CGRect frame1 = [self.view convertRect:sender.frame fromView:sender.superview];
        CGRect frame = CGRectMake(0,0,self.view.frame.size.width, 60);
        
        popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [popView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
        popView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        UIView *toolView = [[UIView alloc]initWithFrame:frame];
        UIButton *doneBtn;
        UILabel *titleLbl;
        if ([Utility sharedInstance].isDeviceIpad )
        {
            contentPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 ,61,self.view.frame.size.width,200)];
            doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -80,20,75,20)];
            [doneBtn.titleLabel setFont:[UIFont fontWithName:@"santana-Bold" size:24]];
            titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200,10,400,40)];
            [titleLbl setFont:[UIFont fontWithName:@"santana-Bold" size:24.0]];

        }
        else
        {
            contentPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 ,61,self.view.frame.size.width,100)];
            doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -50,20,45,20)];
            [doneBtn.titleLabel setFont:[UIFont fontWithName:@"santana-Bold" size:15]];
            titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100,10,200,40)];
            [titleLbl setFont:[UIFont fontWithName:@"santana-Bold" size:15.0]];

        }
        contentPickerView.delegate = self;
        contentPickerView.tag = 102;
        contentPickerView.backgroundColor = [UIColor whiteColor];
        toolView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
       
        [doneBtn setTitle:@"done" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithRed:96/255.0 green:72/255.0 blue:121/255.0 alpha:1] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        //        UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(5,20,65,20)];
        //        [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"santana" size:15]];
        //        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        //        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        

        [titleLbl setText:@"location"];
        [titleLbl setTextAlignment:NSTextAlignmentCenter];
        [titleLbl setTextColor:[UIColor colorWithRed:0 green:0 blue:00 alpha:0.69]];
        //        [titleLbl setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [toolView addSubview:titleLbl];
        [toolView addSubview:doneBtn];
        //        [toolView addSubview:cancelBtn];
        [popView addSubview:toolView];
        [popView addSubview:contentPickerView];
        [self.view addSubview:popView];
    }

    [contentPickerView reloadAllComponents];
}

-(void)backgroundTap
{
    [popView removeFromSuperview];
    [contentPickerView removeFromSuperview];
}

-(void)dismiss
{
    [popView removeFromSuperview];
    [contentPickerView removeFromSuperview];
    
    self.txtLocation.text = locationName;
}

- (void)selectKeyword:(NSString *)keyword
{
    [self.txtLocation setText:keyword];
    [controller.view removeFromSuperview];
}


- (UIImage *)updateImageNamed:(NSString *)name withColor:(UIColor *)color
{
    // load the image
    //NSString *name = @"badge.png";
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
}

#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 101)
        return arrGender.count;
    else
        return googleSearchPlaces.count;
}


//#pragma mark UIPickerViewDelegate Methods

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = @"";
    if (pickerView.tag == 101)
        str = arrGender[row];
    else
       str = googleSearchPlaces[row];

    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 101)
        self.txtGender.text = arrGender[row];
    else
        locationName = googleSearchPlaces[row];
}

-(void)callServiceGetProfile
{
    NSString *userId = [Utility userId];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"SERVICE_GET_MY_PROFILE" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:userId forKey:@"user_id"];

    if ([Utility isNetworkAvailable])
    {
        [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                  responseObject = [Utility convertDictionaryIntoUTF8:[responseObject allValues] dictionary:responseObject];
              }
              [SVProgressHUD dismiss];
              if (!error) {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
                  {
                      NSString *error_code=[responseObject objectForKey:@"error_code"];
                      NSString *error_desc=[responseObject objectForKey:@"error_desc"];
                      UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:error_code message:error_desc preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      [myAlert addAction:action];
                      [self presentViewController:myAlert animated:YES completion:nil];
                  }
                  else
                  {//successful.
                      NSDictionary *userInfo = [responseObject objectForKey:@"profile"];
                      if ([[userInfo objectForKey:@"name"] isKindOfClass:[NSNull class]] )
                          self.txtUserName.text =@"";
                      else
                          self.txtUserName.text = [[userInfo objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                      if ([[userInfo objectForKey:@"email_id"] isKindOfClass:[NSNull class]] )
                          self.txtEmail.text =@"";
                      else
                          self.txtEmail.text = [userInfo objectForKey:@"email_id"];
                      if ([[userInfo objectForKey:@"country"] isKindOfClass:[NSNull class]] )
                          self.txtLocation.text =@"";
                      else
                          self.txtLocation.text = [userInfo objectForKey:@"country"];
                      if ([[userInfo objectForKey:@"sex"] isKindOfClass:[NSNull class]] )
                          self.txtGender.text =@"";
                      else
                      self.txtGender.text = [userInfo objectForKey:@"sex"];
                      if (![[userInfo objectForKey:@"description"] isKindOfClass:[NSNull class]])
                      {
                          NSString *description = [userInfo objectForKey:@"description"];
                          NSInteger textCount = 0;
                          if ([description isEqualToString:@""])
                          {
                              self.selfDescriptionTextView.text = self_Description_Placeholder_Text;
                              self.selfDescriptionTextView.textColor = [UIColor lightGrayColor];
                          }
                          else
                          {
                              self.selfDescriptionTextView.text = description;
                              textCount = description.length;

                              self.selfDescriptionTextView.textColor = [UIColor lightGrayColor];
                          }
                          if ([Utility sharedInstance].isDeviceIpad )
                          {
                              [self.selfDescriptionTextView setFont:[UIFont fontWithName:@"santana-Bold" size:21.0]];
                          }
                          else
                          {
                              [self.selfDescriptionTextView setFont:[UIFont fontWithName:@"santana-Bold" size:17.0]];
                          }
                          self.lblDescriptionTextCount.text = [NSString stringWithFormat:@"%ld/%d",textCount ,MAX_TEXT_LIMIT_FOR_DESCRIPTION];
                      }
                          NSString *imageUrl = [userInfo objectForKey:@"image_name"];
                      UIImage *profileImage = [UIImage imageWithData:imageToUpload];
                      // Get image data. Here you can use UIImagePNGRepresentation if you need transparency
                      NSData *imageData = UIImageJPEGRepresentation(profileImage, 1);
                      
                      // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
                      NSString *imagePath = [Utility documentsPathForFileName:[NSString stringWithFormat:@"profile.jpg"]];
                      
                      // Write image data to user's folder
                      [imageData writeToFile:imagePath atomically:YES];
                      
                      // Store path in NSUserDefaults
                      [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"profileImageUrl"];
                      
                      // Sync user defaults
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      [[Utility sharedInstance] setProfImage:profileImage];
                      
//                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                      [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(profileImage) forKey:@"profileImageUrl"];
//
//                     // [defaults setObject:imageUrl forKey:@"profileImageUrl"];
//                      [defaults synchronize];
                      if (![imageUrl isKindOfClass:[NSNull class]])
                      {
                          SDWebImageManager *manager = [SDWebImageManager sharedManager];
                          [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
                                                options:0
                                               progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                   // progression tracking code
                                               }
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                  if (image) {
                                                      [self.btnSetImage setBackgroundImage:image forState:UIControlStateNormal];
                                                  }
                                              }];
                      }
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
                  
              }
          }] resume];
    }
    else
    {
        [self.view makeToast:@"Network connection seems to be offline"];
    }

}

-(void)callServiceUpdateProfile
{
    NSString *description = self.selfDescriptionTextView.text;
    if ([description isEqualToString:self_Description_Placeholder_Text])
    {
        description = @"";
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"SERVICE_USER_UPDATE_PROFILE" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:[Utility userId] forKey:@"user_id"];
    [dict setObject:self.txtUserName.text forKey:@"name"];
    [dict setObject:self.txtLocation.text forKey:@"country_id"];
    [dict setObject:self.txtGender.text forKey:@"sex"];
    [dict setObject:description forKey:@"descripation"];
    [dict setObject:self.txtGender.text forKey:@"sex"];

    if ([Utility isNetworkAvailable])
    {
        [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                  responseObject = [Utility convertDictionaryIntoUTF8:[responseObject allValues] dictionary:responseObject];
              }
              [SVProgressHUD dismiss];
              if (!error)
              {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
                  {
                      NSString *error_code=[responseObject objectForKey:@"error_code"];
                      NSString *error_desc=[responseObject objectForKey:@"error_desc"];
                      UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:error_code message:error_desc preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      [myAlert addAction:action];
                      [self presentViewController:myAlert animated:YES completion:nil];
                  }
                  else
                  {//successful.
                      [self.view makeToast:@"Profile updated."];
                      //saving name in defaults...//
                      
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      [defaults setObject:[self.txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"userName"];
                      [defaults synchronize];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserNameNotification" object:nil userInfo:nil];

                  }
            }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
                  
              }
          }] resume];
    }
    else
    {
        [self.view makeToast:@"Network connection seems to be offline"];
    }

}

 //======================================
#pragma mark - MultiPart image upload.
//======================================

// Upload Image to server.
- (void) uploadImage
{
    if (!imageToUpload) {
        NOTIFY_AND_LEAVE(@"Please set image before uploading.");
    }
    [SVProgressHUD showWithStatus:@"Uploading image"];
    
    NSString* MultiPartContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    [post_dict setObject:[Utility userId] forKey:User_Id];
    [post_dict setObject:imageToUpload forKey:@"image_name"];
    NSData *postData = [self generateFormDataFromPostDictionaryForImage:post_dict];
    
    post_dict = nil;
    
    NSURL *url = [NSURL URLWithString:Server_Url_For_Upload];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    if (!urlRequest) NOTIFY_AND_LEAVE(@"Error creating the URL Request");
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:MultiPartContentType forHTTPHeaderField: @"Content-Type"];
    [urlRequest setValue:Decode_Type forHTTPHeaderField:Decode];
    [urlRequest setValue:Zipjson_Type forHTTPHeaderField:Zipjson];
    [urlRequest setHTTPBody:postData];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSError *error;
        NSURLResponse *response;
        NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"***** result =%@", result);
            if (!result)
            {
                [self cleanup:[NSString stringWithFormat:@"upload error: %@", [error localizedDescription]]];
                return;
            }
            // Return results
            NSError *error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
            if (json)
            {
                NSString *status = [json objectForKey:@"upload_status"];
                if (![status length]) {
                    status = @"Success";
                }
                if (status) {
                    [self.view makeToast:[json objectForKey:@"upload_status"]];
                }
                }
            UIImage *profileImage = [UIImage imageWithData:imageToUpload];
            // Get image data. Here you can use UIImagePNGRepresentation if you need transparency
            NSData *imageData = UIImageJPEGRepresentation(profileImage, 1);
            
            // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
            NSString *imagePath = [Utility documentsPathForFileName:[NSString stringWithFormat:@"profile.jpg"]];
            
            // Write image data to user's folder
            [imageData writeToFile:imagePath atomically:YES];
            
            // Store path in NSUserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"profileImageUrl"];
            
            // Sync user defaults
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [self.btnSetImage setBackgroundImage:profileImage forState:UIControlStateNormal];
            
            [[Utility sharedInstance] setProfImage:profileImage];

            
            //saving the imageUrl in defaults...//
            
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(profileImage) forKey:@"profileImageUrl"];
//
//            //[defaults setObject:profileImage forKey:@"profileImageUrl"];
//            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserNameNotification" object:nil userInfo:nil];
            NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"***** outstring =%@", outstring);
            [self cleanup: [json objectForKey:@"upload_status"]];
        });
    });
    
}

// convert ticket id and image in to mutipart data.
- (NSData*)generateFormDataFromPostDictionaryForImage:(NSDictionary*)dict
{
    NSMutableData* result = [NSMutableData data];
    
    
    // add user id into mutipart data
    [result appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",User_Id] dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[[NSString stringWithFormat:@"%@",[dict objectForKey:User_Id]] dataUsingEncoding:NSUTF8StringEncoding]];
    

    // add image into multipart data
    [result appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, @"image_name"];
    [result appendData: DATA(formstring)];
    id value = [dict objectForKey:@"image_name"];
    [result appendData:value];
    
    [result appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
   
    return result;
}

- (void) cleanup: (NSString *) output
{
    [SVProgressHUD dismiss];
    if (output) {
        [self.view makeToast:output];
        NSLog(@"******** %@", output);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePasswordBtnActn:(id)sender
{
    ChangePasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)dashBoardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}

- (IBAction)signOutBtnActn:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"SignOut" message:@"Are you sure you want to SignOut?" preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                            {
                            }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"SignOut" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                [userDefaults setBool:NO forKey:@"loggedIn"];
                                [userDefaults removeObjectForKey:@"u_id"];
                                [userDefaults removeObjectForKey:@"userName"];
                                [userDefaults removeObjectForKey:@"profileImageUrl"];
                                [userDefaults synchronize];
                                
                                AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                [appDel setRootViewController:appDel.dashBoardViewController];
                            }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

@end
