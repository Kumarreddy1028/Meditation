//
//  ChangePasswordViewController.m
//  Meditation
//
//  Created by IOS-2 on 08/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIImageView *tickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
- (IBAction)txtNewPswdChangeEvent:(id)sender;
- (IBAction)txtConfirmPswdChangeEvent:(id)sender;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtOldPassword.attributedPlaceholder = [Utility changePasswordplaceholder:@"old password"];
    self.txtNewPassword.attributedPlaceholder = [Utility changePasswordplaceholder:@"new password"];
    self.txtConfirmPassword.attributedPlaceholder = [Utility changePasswordplaceholder:@"confirm new password"];
    
    _txtConfirmPassword.delegate=self;
    _txtNewPassword.delegate=self;
    _txtOldPassword.delegate=self;

    self.changePasswordBtn.layer.cornerRadius=5.0;
    self.changePasswordBtn.clipsToBounds=YES;
   
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    return YES;
}
-(void)callServiceChangePassword
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_CHANGE_PASSWORD" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[Utility userId] forKey:@"user_id"];
    [dict setObject:self.txtOldPassword.text forKey:@"old_password"];
    [dict setObject:self.txtNewPassword.text forKey:@"new_password"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:@"2561456" forKey:@"device_token"];
    [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          { if ([responseObject isKindOfClass:[NSDictionary class]])
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
                  {
                  
                      
                      UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"password changed." preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                              {
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              }];
                      [myAlert addAction:action];
                      [self presentViewController:myAlert animated:YES completion:nil];
                    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePasswordBtnActn:(id)sender
{
    //-------null check-------//
    
    if ([Utility isEmpty:_txtOldPassword.text] || [Utility isEmpty:_txtNewPassword.text] || [Utility isEmpty:_txtConfirmPassword.text])
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"All the fields are mandatory." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    
    else if (![_txtNewPassword.text isEqualToString:_txtConfirmPassword.text])
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"new password and confirm password is not same" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    else
        [self callServiceChangePassword];
}

- (IBAction)backBtnActn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD dismiss];

}
- (IBAction)txtNewPswdChangeEvent:(id)sender
{
    UITextField *textField = sender;
    if ([textField.text isEqualToString:_txtConfirmPassword.text] && [textField hasText])
    {
            [_tickImageView setImage:[UIImage imageNamed:@"check"]];
            self.changePasswordBtn.enabled=YES;
            self.changePasswordBtn.userInteractionEnabled=YES;
            self.changePasswordBtn.alpha=1.0;
        }
        else
        {
            [_tickImageView setImage:[UIImage imageNamed:@""]];
            self.changePasswordBtn.enabled=NO;
            self.changePasswordBtn.userInteractionEnabled=NO;
            self.changePasswordBtn.alpha=0.5;
            
        }

   
}

- (IBAction)txtConfirmPswdChangeEvent:(id)sender
{
    UITextField *textField = sender;
    if ([_txtNewPassword.text isEqualToString:textField.text] && [textField hasText])
    {
        [_tickImageView setImage:[UIImage imageNamed:@"check"]];
        self.changePasswordBtn.enabled=YES;
        self.changePasswordBtn.userInteractionEnabled=YES;
        self.changePasswordBtn.alpha=1.0;
    }
    else
    {
        [_tickImageView setImage:[UIImage imageNamed:@""]];
        self.changePasswordBtn.enabled=NO;
        self.changePasswordBtn.userInteractionEnabled=NO;
        self.changePasswordBtn.alpha=0.5;
        
    }
}
@end
