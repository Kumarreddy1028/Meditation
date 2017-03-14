//
//  SignInViewController.m
//  Meditation
//
//  Created by IOS1-2016 on 11/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#define platform_id_Facebook @"1"
#define platform_id_Twitter @"2"
#define platform_id_Google @"3"
#define Logo_size_increase 30
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "AlreadySignedInViewController.h"
#import "AppDelegate.h"

@interface SignInViewController ()<SignUpViewControllerDelegate, GIDSignInDelegate ,GIDSignInUIDelegate>

@end

@implementation SignInViewController
{
    NSString *SocialPlatformUserId;
    NSString *SocialPlatformName;
    NSString *SocialPlatformEmail;
}


#pragma mark- viewLifecycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.forgetPasswordButton.layer.cornerRadius = 5.0;
    self.forgetPasswordButton.clipsToBounds = YES;
    self.signInButton.layer.cornerRadius = 5.0;
    self.signInButton.clipsToBounds = YES;
    self.signUpButton.layer.cornerRadius = 5.0;
    self.signUpButton.clipsToBounds = YES;
    SocialPlatformName = @"";
    SocialPlatformEmail = @"";
    SocialPlatformUserId = @"";
    self.navigationController.navigationBarHidden = YES;
    [GIDSignIn sharedInstance].clientID = Google_Client_ID;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [self.blurView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [self registerForNotifications];
    self.txtUserId.attributedPlaceholder = [Utility placeholder:@"email address"];
    self.txtPassword.attributedPlaceholder = [Utility placeholder:@"password"];

}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twitterTokenHandler:)name:@"twitterTokenVerifier" object:nil];
}

-(void)twitterTokenHandler:(NSNotification *)notification
{
    NSString *token = [[notification userInfo]objectForKey:@"oauth_token"];
    NSString *verifier = [[notification userInfo]objectForKey:@"oauth_verifier"];
    [self setOAuthToken:token oauthVerifier:verifier];
}

- (IBAction)signInActionButton:(id)sender
{
    NSString *emailString = self.txtUserId.text;
    NSString *textPassword = self.txtPassword.text;
    //-------null check-------//
    
    if ([Utility isEmpty:textPassword] || [Utility isEmpty:emailString])
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
                                     [self.txtUserId becomeFirstResponder];
                                 }];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }

   else if([Utility isNetworkAvailable])
   {
    
    //----WEB SERVICES---------//
    
//    [SVProgressHUD showWithStatus:@"Signing in"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_LOGIN" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:self.txtUserId.text forKey:@"email_id"];
    [dict setObject:self.txtPassword.text forKey:@"u_password"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:@"5345" forKey:@"device_token"];
    [dict setObject:[Utility userId] forKey:@"temp_id"];

       [self callServiceUserRegistrationWithDictionary:dict];
   }
//    else
//    {
//        [self.view makeToast:@"network connection seems to be offline."];
//    }
        [self resignFirstResponder];
}

- (IBAction)forgetPasswordActionButton:(id)sender
{
    self.blurView.hidden = NO;
}

- (IBAction)createAccountActionButton:(id)sender
{
    SignUpViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
    controller.SignUpViewControllerDelegate = self;
    controller.txtEmailString = self.txtUserId.text;
    controller.txtPasswordString = self.txtPassword.text;
    [self presentViewController:controller animated:YES completion:nil];
}
//- (IBAction)backActionButton:(id)sender
//{
////    [self.navigationController popToRootViewControllerAnimated:YES];
//     [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
//}

- (IBAction)cancelActionButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButtonAction:(id)sender
{
    BOOL emailIsOk = [self validateEmailWithString:self.txtForgetEmail.text];
    if (emailIsOk)
    {
        NSDictionary *dictionary = @{@"REQUEST_TYPE_SENT":@"SERVICE_FORGOT_PASSWORD",
                                             @"email_id":self.txtForgetEmail.text,
                                             @"device_type":@"2",
                                             @"device_token":[[Utility sharedInstance] getDeviceToken],
                                             };
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:dictionary];

        [self callServiceForgetPasswordWithDictionary:dict];
    }
    else
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"please enter a valid email id" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
}

- (IBAction)blurViewTapGestureRecogniserAction:(id)sender
{
    self.blurView.hidden = YES;
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
#pragma mark- SignUpViewControllerDelegate method.
-(void)didSignUp
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark- Google SignIn

- (IBAction)googleSignInActionButton:(id)sender
{
    [[GIDSignIn sharedInstance] signIn];
}

//==================================================================
#pragma mark - Google SignIn Delegate
//==================================================================

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    [SVProgressHUD dismiss];
    //    [self.view makeToast:error.localizedDescription];
}
// Present a view that prompts the user to sign in with Google

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}
// Dismiss the "Sign in with Google" view

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD show];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    SocialPlatformUserId = user.userID;
    //    NSString *idToken = user.authentication.idToken;
    SocialPlatformName= user.profile.name;
    SocialPlatformEmail = user.profile.email;
    if(user)
    {
   

        NSDictionary *userInfo = @{@"REQUEST_TYPE_SENT":@"SERVICE_REGISTRATION_BY_SOCIAL_SITE",
                                   @"email_id":SocialPlatformEmail,
                                   @"name":SocialPlatformName,
                                   @"social_app_id":SocialPlatformUserId,
                                   @"platform_id":platform_id_Google,
                                   @"device_type":@"2",
                                   @"device_token":@"5345",
                                   @"temp_id":[Utility userId],
                                   };
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:userInfo];
        [self callServiceUserRegistrationWithDictionary:dict];
    }
}

//==================================================================
#pragma mark- Facebook SignIn
//==================================================================

- (IBAction)facebookSignInActionButton:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error-%@",error.localizedDescription);
             [self.view makeToast:error.localizedDescription];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         }
         else
         {
             //........successfully logged in........//
             
             SocialPlatformUserId = [[FBSDKAccessToken currentAccessToken] userID];
             NSLog(@"USER ID %@",SocialPlatformUserId);
             NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[FBSDKAccessToken currentAccessToken] userID]];
             NSLog(@"USER IMAGE URL %@",userImageURL);
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name, first_name, last_name, picture.type(large), email"}]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (!error)
                  {
                      SocialPlatformUserId = [result objectForKey:@"id"];
                      SocialPlatformName = [result objectForKey:@"name"];
                      SocialPlatformEmail = [result objectForKey:@"email"];
                      //......creating dictionary to call service.....//
                      
                      NSDictionary *userInfoDictionary = @{@"REQUEST_TYPE_SENT":@"SERVICE_REGISTRATION_BY_SOCIAL_SITE",
                                                           @"email_id":SocialPlatformEmail,
                                                           @"name":SocialPlatformName,
                                                           @"social_app_id":SocialPlatformUserId,
                                                           @"platform_id":platform_id_Facebook,
                                                           @"device_type":@"2",
                                                           @"device_token":@"5345",
                                                           @"temp_id":[Utility userId],
                                                           };
                      NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:userInfoDictionary];
                      
                      [self callServiceUserRegistrationWithDictionary:dict];

                  }
                  else
                  {
                      [self.view makeToast:@"Encountered an error"];
                  }
              }];
             
                      }
     }];
}

//==================================================================
#pragma mark - Twitter Integration
//==================================================================

- (IBAction)loginWithTwitter:(id)sender
{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:Twitter_Consumer_Key
                                                 consumerSecret:Twitter_Consumer_Secret];
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        [[UIApplication sharedApplication] openURL:url];
    } authenticateInsteadOfAuthorize:NO
                    forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:@"myapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                    }];
    
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName)
     {
         NSLog(@"-- screenName: %@", screenName);
         
         NSLog(@"%@",[NSString stringWithFormat:@"%@ (%@)", screenName, userID]);
         SocialPlatformName = screenName;
         SocialPlatformUserId = userID;
         
         //......creating dictionary to call service.....//
         
         NSDictionary *userInfoDictionary = @{@"REQUEST_TYPE_SENT":@"SERVICE_REGISTRATION_BY_SOCIAL_SITE",
                                              @"email_id":SocialPlatformEmail,
                                              @"name":SocialPlatformName,
                                              @"social_app_id":SocialPlatformUserId,
                                              @"platform_id":platform_id_Twitter,
                                              @"device_type":@"2",
                                              @"device_token":@"5345",
                                              @"temp_id":[Utility userId],
                                              };
         NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:userInfoDictionary];

         [self callServiceUserRegistrationWithDictionary:dict];
         
         
     } errorBlock:^(NSError *error) {
         NSLog(@"-- %@", [error localizedDescription]);
     }];
}

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    if(twitterAPI != _twitter) return;
    NSLog(@"-- account was invalidated: %@ | %@", invalidatedAccount, invalidatedAccount.username);
}


#pragma mark-SERVICE REGISTRATION

-(void)callServiceUserRegistrationWithDictionary:(NSDictionary *)dict
{
    if (![Utility isNetworkAvailable])
{
    return;
}
    [SVProgressHUD showWithStatus:@"Signing in"];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              [SVProgressHUD dismiss];

              if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                  responseObject = [Utility convertDictionaryIntoUTF8:[responseObject allValues] dictionary:responseObject];
              }
              if (!error) {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
                  {
                      NSString *error_code=[responseObject objectForKey:@"error_code"];
                      NSString *error_desc=[responseObject objectForKey:@"error_desc"];
                      UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Invalid Credentials" preferredStyle:UIAlertControllerStyleAlert];
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
                      [defaults setObject:[responseObject objectForKey:@"image_name"] forKey:@"profileImageUrl"];
                      [defaults synchronize];
                      [[Utility sharedInstance] getCurrentLocationAndRegisterDeviceToken];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserNameNotification" object:nil userInfo:nil];

                      [self.view makeToast:@"Signed in."];
                      [self dismissViewControllerAnimated:YES completion:nil];
                      
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

-(void)callServiceForgetPasswordWithDictionary:(NSDictionary *)dict
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
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
              self.txtForgetEmail.text = @"";
              if (!error) {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
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
                      self.blurView.hidden = YES;
                      [self.txtForgetEmail resignFirstResponder];
                      UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Password Sent" message:@"Your password has been sent to your registered e-mail address." preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                               {
                                                   
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
    
//    else
//    {
//        [self.view makeToast:@"Network connection seems to be offline"];
//    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
