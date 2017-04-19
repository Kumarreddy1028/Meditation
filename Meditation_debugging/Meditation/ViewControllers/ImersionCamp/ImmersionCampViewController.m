//
//  ImmersionCampViewController.m
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "ImmersionCampViewController.h"
#import "SignInViewController.h"
#import "SocialShareViewController.h"

@interface ImmersionCampViewController ()
{
    NSArray *imageStr;
    UIImage *pass;
}

@end

@implementation ImmersionCampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    [self.eventTitle setText:self.event.eventName];
    [self.eventDescTextView setText:self.event.eventDescription];
    [self.eventDescTextView setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15.0]];
   
    NSString *str = [NSString stringWithFormat:@"Meditation Camp: %@ - %@\n\n",self.event.startOn, self.event.endOn];
    NSMutableString *total = [NSMutableString new];
    [total appendString:str];
    [total appendString:[NSString stringWithFormat:@"%@",self.event.heading]];
    [total appendString:[NSString stringWithFormat:@"\n\n%@ spots left",self.event.seat]];
    [total appendString:[NSString stringWithFormat:@"\n\n%@",self.event.eventDescription]];
    
    self.shareView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.shareView.layer.borderWidth = 1.0;
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:total];
    UIColor *color;
    CGFloat fontSize;
    if ([Utility sharedInstance].isDeviceIpad)
    {
        color = [UIColor whiteColor];
        fontSize = 20.0;
    }
    else
    {
        color = [UIColor blackColor];
        fontSize = 15.0;
    }
    NSDictionary *attrsDictionary = @{
                               NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize],
                               NSForegroundColorAttributeName : color
                               };
    [string addAttributes:attrsDictionary range:NSMakeRange(0,str.length)];
    NSDictionary *attrsDictionary1 = @{
                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                      NSForegroundColorAttributeName : color
                                      };
    [string addAttributes:attrsDictionary1 range:NSMakeRange(str.length,self.event.heading.length)];
    NSDictionary *attrsDictionary2 = @{
                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize],
                                      NSForegroundColorAttributeName : color
                                      };
    [string addAttributes:attrsDictionary2 range:NSMakeRange(str.length+self.event.heading.length, self.event.seat.length+15)];

    NSDictionary *attrsDictionary3 = @{
                                      NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize],
                                      NSForegroundColorAttributeName : color
                                      };
    [string addAttributes:attrsDictionary3 range:NSMakeRange(str.length+self.event.heading.length+self.event.seat.length+15,self.event.eventDescription.length)];

    self.eventDescTextView.attributedText = string;

    if ([Utility sharedInstance].isDeviceIpad)
    {
        [self.backBtn setHidden:YES];
    }
    [self.eventDescTextView setTextContainerInset:UIEdgeInsetsMake(15, 15, 15, 15)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnActn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerbtnActn:(id)sender
{
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];

    if (!loggedIn)
    {
        //user is not logged in.
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Please sign-in" message:@"You need to be signed to register this event" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"sign-in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           SignInViewController *signInController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                           [self presentViewController:signInController animated:YES completion:nil];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"not now" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:signInAction];
        [myAlert addAction:cancelAction];
        [self presentViewController:myAlert animated:YES completion:nil];
        return;
    }
    else
    {
    
        if (![Utility isNetworkAvailable])
            
        {
            [self.view makeToast:@"Network connection seems to be offline"];
            return;
        }
        if ([self.event.isRegistered isEqualToString:@"1"])
        {
            UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You are already registered in this event" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [myAlert addAction:cancelAction];
            [self presentViewController:myAlert animated:YES completion:nil];
            return;
        }
        NSMutableDictionary *dic= [[NSMutableDictionary alloc]init];
        [dic setObject:@"SERVICE_USER_EVENT_REGISTRATION" forKey:@"REQUEST_TYPE_SENT"];
        [dic setObject:[Utility userId] forKey:User_Id];
        [dic setObject:self.event.eventID forKey:@"event_id"];
        [dic setObject:@"2" forKey:@"device_type"];
        [dic setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
        [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dic];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              [SVProgressHUD dismiss];

              if (!error)
              {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if ([responseObject isKindOfClass:[NSDictionary class]])
                  {
                      if (![Utility sharedInstance].isDeviceIpad) {
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
              }
          }] resume];
        
}
}
- (IBAction)shareBtnAction:(UIButton *)sender {
    SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
    if ([Utility sharedInstance].isDeviceIpad)
    {
        cont.isPad = YES;
    }
    cont.navigated = YES;
    cont.titleLabelString = @"share this event";
    cont.textToShare = _eventDescTextView.text;
    [self.navigationController pushViewController:cont animated:YES];
}

@end
