//
//  SignUpViewController.m
//  Meditation
//
//  Created by IOS1-2016 on 10/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

#pragma mark- View lifecycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.signUpButton.layer.cornerRadius = 5.0;
    self.signUpButton.clipsToBounds = YES;
      self.navigationController.navigationBarHidden = YES;
    self.txtEmail.text = self.txtEmailString;
    self.txtPassword.text = self.txtPasswordString;
    self.txtEmail.attributedPlaceholder = [Utility placeholder:@"email address"];
    self.txtName.attributedPlaceholder = [Utility placeholder:@"user name"];
    self.txtPassword.attributedPlaceholder = [Utility placeholder:@"password"];
}

#pragma mark- IBAction methods.

- (IBAction)cancelActionButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtPassword)
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        return YES;
    }
    else
    {
        return YES;
  
    }
   
}
- (IBAction)signUpActionButton:(id)sender
{
    NSString *nameString = self.txtName.text;
    NSString *PasswordString = self.txtPassword.text;
    NSString *emailString = self.txtEmail.text;
    
    //--------null check-------//
    
    if ([Utility isEmpty:PasswordString] || [Utility isEmpty:emailString])
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"All the fields are mandatory." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    
    //------e-mail validation------//
    
    else if (![self validateEmailWithString:emailString])
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter a valid email address." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self.txtEmail becomeFirstResponder];
                                 }];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    else
    {
        // ..........web Services..............//
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"SERVICE_USER_REGISTRATION_EMAIL" forKey:@"REQUEST_TYPE_SENT"];
        [dict setObject:self.txtEmail.text forKey:@"email_id"];
        [dict setObject:@"" forKey:@"user_name"];
        [dict setObject:self.txtName.text forKey:@"name"];
        [dict setObject:self.txtPassword.text forKey:@"u_password"];
        [dict setObject:@"" forKey:@"sex"];
        [dict setObject:@"" forKey:@"dob"];
        [dict setObject:@"" forKey:@"phone_no"];
        [dict setObject:@"" forKey:@"address"];
        [dict setObject:@"" forKey:@"descripation"];
        [dict setObject:@"2" forKey:@"device_type"];
        [dict setObject:@"5345" forKey:@"device_token"];
        [dict setObject:[Utility userId] forKey:@"temp_id"];

        [self callServiceUserRegistrationWithDictionary:dict];
    }
        
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailFormat = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailFormat];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - textField delegate methods.

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


#pragma mark-SERVICE REGISTRATION

-(void)callServiceUserRegistrationWithDictionary:(NSDictionary *)dict
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    [SVProgressHUD showWithStatus:@"Signing up"];
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
              if (responseObject[@"error_code"])//if response object contains a key named error_code.
              {
                  NSString *error_code=[responseObject objectForKey:@"error_code"];
                  NSString *error_desc=[responseObject objectForKey:@"error_desc"];
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:error_desc preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
              }
              else
              {
                  //setting logged in.
                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                  [defaults setBool:YES forKey:@"loggedIn"];
                  //setting user id.
                  NSString *uid=[responseObject objectForKey:@"user_id"];
                  [defaults setObject:uid forKey:@"u_id"];
                  //setting userName.
                  NSString *userName = [responseObject objectForKey:@"name"];
                  [defaults setObject:userName forKey:@"userName"];
                  [defaults synchronize];
                  [[Utility sharedInstance] getCurrentLocationAndRegisterDeviceToken];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserNameNotification" object:nil userInfo:nil];
                  [self.view makeToast:@"Signed up."];

                  [self dismissViewControllerAnimated:YES completion:^{
                      [self.SignUpViewControllerDelegate didSignUp];
                  }];
                  
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
//    else
//    {
//        [self.view makeToast:@"Network connection seems to be offline"];
//    }

//.........//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
