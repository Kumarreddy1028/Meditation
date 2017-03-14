//
//  Buy_BooksViewController.m
//  Meditation
//
//  Created by IOS-2 on 02/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "Buy_BooksViewController.h"

@interface Buy_BooksViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblBookTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBookSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBookPrice;
@property (weak, nonatomic) IBOutlet UITextView *bookDescriptionTextView;
- (IBAction)shareBtnActn:(id)sender;
- (IBAction)buyBookButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBookBtn;
- (IBAction)backBtnActn:(id)sender;
@property(nonatomic, assign)CLLocationCoordinate2D annotationCoord;
@property(nonatomic, strong)CLLocationManager *locationManager;
@property(nonatomic, assign)BOOL didFindLocation;

@end

@implementation Buy_BooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblBookTitle.text = _book.bookName;
    _lblBookSubTitle.text = _book.bookSubtitle;
    _lblBookPrice.text = _book.overview;
    self.shareBtn.layer.cornerRadius = 5.0;
    self.shareBtn.clipsToBounds=YES;
    self.buyBookBtn.layer.cornerRadius = 5.0;
    self.buyBookBtn.clipsToBounds=YES;
    self.bookDescriptionTextView.attributedText = [Utility changeLineSpacing:self.book.bookDescription];
    [self.bookDescriptionTextView setTextContainerInset:UIEdgeInsetsMake(15, 14, 15, 14)];
    self.bookDescriptionTextView.textColor=[UIColor colorWithRed:66/255.0 green:60/255.0 blue:79/255.0 alpha:1];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_book.bookImageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    [_bookImageView setImage:image];
    float ratingFloat = [_book.bookRating floatValue];
    int ratingInteger = ratingFloat;
    for (int i = 1; i <= 5; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        if (button.tag <= ratingInteger)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"books_rating_star"] forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"books_rating_star_unfill"] forState:UIControlStateNormal];
        }
    }
    if (ratingFloat - ratingInteger)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:ratingInteger + 1];
        [button setBackgroundImage:[UIImage imageNamed:@"books_rating_star_halffill"] forState:UIControlStateNormal];
    }

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

- (IBAction)shareBtnActn:(id)sender
{
    SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
    cont.navigated = YES;
    cont.titleLabelString = @"share this book";
//    cont.textToShare = self.book.bookUrl ;
    NSString *country = [Utility sharedInstance].country;
    if (country == nil)
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Location" message:@"PPE wants to detect your Location" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
                                 }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Don't Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action2)
                                  {
                                      UIAlertController *myAlert2 = [UIAlertController alertControllerWithTitle:@"Alert" message:@"PPE wants to navigate on." preferredStyle:UIAlertControllerStyleAlert];
                                      UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Amazon.in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                {
                                                                    cont.textToShare = self.book.bookUrl ;
                                                                }];
                                      UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"Amazon.com" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                {
                                                                    cont.textToShare = self.book.countryUrl ;
                                                                }];
                                      [myAlert2 addAction:action3];
                                      [myAlert2 addAction:action4];
                                      [self presentViewController:myAlert2 animated:YES completion:nil];
                                      
                                  }];
        [myAlert addAction:action];
        [myAlert addAction:action2];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    else
    {
        if ([country isEqualToString:@"India"])
        {
            cont.textToShare = self.book.bookUrl ;
        }
        else
        {
            cont.textToShare = self.book.countryUrl ;
        }
    }

    [self.navigationController pushViewController:cont animated:YES];
}

- (IBAction)buyBookButtonAction:(id)sender
{
//    NSURL *buyUrl = [NSURL URLWithString:self.book.bookUrl];
//
//    if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
//    {
//        [[UIApplication sharedApplication] openURL: buyUrl];
//    }
    [[Utility sharedInstance] getCurrentLocationAndRegisterDeviceToken];
    NSString *country = [Utility sharedInstance].country;
    if (country == nil)
    {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location"
        //                                                            message:@"PPE wants to detect your Location"
        //                                                           delegate:self
        //                                                  cancelButtonTitle:@"Settings"
        //                                                  otherButtonTitles:@"cancel"];
        //            [alert show];
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Location" message:@"PPE wants to detect your Location" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
                                     [self getCurrentLocationAndRegisterDeviceToken];

                                 }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Don't Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action2)
                                  {
                                      UIAlertController *myAlert2 = [UIAlertController alertControllerWithTitle:@"Alert" message:@"PPE wants to navigate on." preferredStyle:UIAlertControllerStyleAlert];
                                      UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Amazon.in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                {
                                                                    NSURL *buyUrl = [NSURL URLWithString:self.book.bookUrl];
                                                                    
                                                                    if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
                                                                    {
                                                                        [[UIApplication sharedApplication] openURL: buyUrl];
                                                                    }
                                                                }];
                                      UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"Amazon.com" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                {
                                                                    NSURL *buyUrl = [NSURL URLWithString:self.book.countryUrl];
                                                                    
                                                                    if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
                                                                    {
                                                                        [[UIApplication sharedApplication] openURL: buyUrl];
                                                                    }
                                                                }];
                                      [myAlert2 addAction:action3];
                                      [myAlert2 addAction:action4];
                                      [self presentViewController:myAlert2 animated:YES completion:nil];
                                      
                                  }];
        [myAlert addAction:action];
        [myAlert addAction:action2];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    else
    {
        if ([country isEqualToString:@"India"])
        {
            NSURL *buyUrl = [NSURL URLWithString:self.book.bookUrl];
            
            if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
            {
                [[UIApplication sharedApplication] openURL: buyUrl];
            }
        }
        else
        {
            NSURL *buyUrl = [NSURL URLWithString:self.book.countryUrl];
            
            if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
            {
                [[UIApplication sharedApplication] openURL: buyUrl];
            }
        }
    }

}

- (void)getCurrentLocationAndRegisterDeviceToken
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    _didFindLocation = NO;
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [_locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [_locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [SVProgressHUD dismiss];
    //[self switchToHomeScreen];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    if (!_didFindLocation) {
        _didFindLocation = YES;
        [_locationManager stopUpdatingLocation];
        _annotationCoord = newLocation.coordinate;
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [Utility sharedInstance].annotationCoord = _annotationCoord;
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            //..NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0)
            {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                [SVProgressHUD dismiss];
                
                placemark = [placemarks lastObject];
                [Utility sharedInstance].country = placemark.country;
                if (placemark.country == nil)
                {
                }
                else
                {
                if ([placemark.country isEqualToString:@"India"])
                {
                    NSURL *buyUrl = [NSURL URLWithString:self.book.bookUrl];
                    
                    if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
                    {
                        [[UIApplication sharedApplication] openURL: buyUrl];
                    }
                }
                else
                {
                    NSURL *buyUrl = [NSURL URLWithString:self.book.countryUrl];
                    
                    if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
                    {
                        [[UIApplication sharedApplication] openURL: buyUrl];
                    }
                }
                }
                
            } else {
            }
        } ];
        
    }
}


- (IBAction)backBtnActn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
