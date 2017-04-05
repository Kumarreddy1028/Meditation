//
//  BooksViewController.m
//  Meditation
//
//  Created by IOS-2 on 31/05/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "BooksViewController.h"
#import "BooksCollectionViewCell.h"
#import "BooksModelClass.h"
#import "UIImageView+WebCache.h"
#import "Buy_BooksViewController.h"

@interface BooksViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
@property(nonatomic, assign)CLLocationCoordinate2D annotationCoord;
@property(nonatomic, strong)CLLocationManager *locationManager;
@property(nonatomic, assign)BOOL didFindLocation;

@end

@implementation BooksViewController

{
    NSMutableArray *arrBooksModelObjects;
//    NSMutableArray *arrBooks;
    BOOL isServiceCalled;
    BOOL isCallingService;
    BOOL moreBooksAvailable;
    BooksModelClass *bookToShow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.gastureView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    arrBooksModelObjects = [NSMutableArray new];
//    arrBooks = [NSMutableArray new];
    [self serviceGetBooks:@"0"];
//    UIButton *Btn = [[UIButton alloc]init];
//    [Btn performSelector:@selector(abc) withObject:self afterDelay:0.1];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(abc) object:nil];

    
}
-(void)tap
{
    if (bookToShow) {
        Buy_BooksViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Buy_BooksViewController"];
        bookToShow = [arrBooksModelObjects objectAtIndex:0];

        vc.book = bookToShow;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)showBook
{
    _lblBookTitle.text = bookToShow.bookName;
    _lblBookSubTitle.text = bookToShow.bookSubtitle;
    _lblBookPrice.text = bookToShow.bookPrice;
    _lblBookDescription.text = bookToShow.overview;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:bookToShow.bookImageUrl]];
    UIImage *image = [UIImage imageWithData:data];
    [_btnBook setBackgroundImage:image forState:UIControlStateNormal];
    float ratingFloat = [bookToShow.bookRating floatValue];
    int ratingInteger = ratingFloat;
    for (int i = 1; i <= 5; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:(100*i)];
        if (button.tag <= ratingInteger*100)
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
        UIButton *button = (UIButton *)[self.view viewWithTag:ratingInteger*100 + 100];
        [button setBackgroundImage:[UIImage imageNamed:@"books_rating_star_halffill"] forState:UIControlStateNormal];
    }
    
}

#pragma mark- Service Call methods

-(void)serviceGetBooks:(NSString *)booksId
{
    //----WEB SERVICES---------//
    [SVProgressHUD show];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if ([countryCode isEqualToString:@"IN"])
    {
        [dict setObject:@"SERVICE_GET_BOOKS" forKey:@"REQUEST_TYPE_SENT"];
        [dict setObject:booksId forKey:@"bookId"];
        [dict setObject:@"0" forKey:@"indiaIs"];

    }
    else{
        [dict setObject:@"SERVICE_GET_BOOKS" forKey:@"REQUEST_TYPE_SENT"];
        [dict setObject:booksId forKey:@"bookId"];
        [dict setObject:@"1" forKey:@"indiaIs"];
    }
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          
          if ([responseObject isKindOfClass:[NSDictionary class]])
          {
              responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
          }
          [SVProgressHUD dismiss];
          if (!error)
          {
              isCallingService = NO;
              NSLog(@"Reply JSON: %@", responseObject);
              if (responseObject[@"error_code"])//if response object contains a key named error_code.
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
                  NSArray *arrBooksList = [responseObject objectForKey:@"books"];
                  if (arrBooksList.count)
                  {
                      self.btnBook.hidden = NO;
                      self.shareBook.hidden = NO;
                      self.buyBook.hidden = NO;

                      for (NSDictionary *dictBooksInfo in arrBooksList )
                      {
                          BooksModelClass *obj = [[BooksModelClass alloc]initWithDictionary:dictBooksInfo];
                          [arrBooksModelObjects addObject:obj];
                      }
                      [self.booksCollectionView reloadData];
                      moreBooksAvailable = YES;
                  }
                  else
                  {
                      moreBooksAvailable = NO;
                  }
                  if (!isServiceCalled)
                  {
                      isServiceCalled = YES;
                      if ([arrBooksModelObjects count]) {
                          bookToShow = [arrBooksModelObjects objectAtIndex:0];
                          [self showBook];
                      }
                     
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
              UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"something went wrong" preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
              [myAlert addAction:action];
              [self presentViewController:myAlert animated:YES completion:nil];
          }
      }] resume];
}

#pragma mark- UICollectionView DataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"arrBooksModelObjects.count - 1 %lu", (arrBooksModelObjects.count - 1));
    return arrBooksModelObjects.count - 1;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return CGSizeMake(self.view.frame.size.width/3-15,150);
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BooksCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"books" forIndexPath:indexPath];
    BooksModelClass *obj = [arrBooksModelObjects objectAtIndex:indexPath.item + 1];
    
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:obj.bookImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.title = obj.bookName;
    
    cell.bookRating = obj.bookRating;
    [cell configureStars];
    return cell;
}

#pragma mark- UICollectionView Delegate methods.

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    bookToShow = [arrBooksModelObjects objectAtIndex:indexPath.item + 1];
//    [arrBooksModelObjects replaceObjectAtIndex:indexPath.item + 1 withObject:[arrBooksModelObjects objectAtIndex:0]];
//    [arrBooksModelObjects replaceObjectAtIndex:0 withObject:bookToShow];
//    [_booksCollectionView reloadData];
//    [self showBook];
    Buy_BooksViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Buy_BooksViewController"];
    vc.book = bookToShow;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- UIScrollView Delegate methods.

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (scrollView.tag == 1)
//    {
        //news tableView.
        if (moreBooksAvailable)
        {
            float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (endScrolling >= scrollView.contentSize.height)
            {
                //scrolled to the bottom.
                if (!isCallingService)
                {
                    //if service is not getting called then only call service.
                    isCallingService = YES;
                    BooksModelClass *book = [arrBooksModelObjects lastObject];
                    if (book)
                    {
                        [self serviceGetBooks:book.bookId];
                    }
                }
            }
        }
        return;
//    }
}

#pragma mark- IBAction methods.

- (IBAction)shareBtnActn:(id)sender
{
    SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
    cont.navigated = YES;
    cont.titleLabelString = @"share this book";
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
                                                                        cont.textToShare = bookToShow.bookUrl ;
                                                                }];
                                      UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"Amazon.com" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                {
                                                                        cont.textToShare = bookToShow.countryUrl ;
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
                cont.textToShare = bookToShow.bookUrl ;
        }
        else
        {
                cont.textToShare = bookToShow.countryUrl ;
        }
    }

    [self.navigationController pushViewController:cont animated:YES];
    
}

- (IBAction)buyBookBtnActn:(id)sender
{
//    NSURL *buyUrl = [NSURL URLWithString:bookToShow.bookUrl];
//    
//    if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
//    {
//        [[UIApplication sharedApplication] openURL: buyUrl];
//    }
    
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
                                     [SVProgressHUD show];
                                     [self getCurrentLocationAndRegisterDeviceToken];

                                 }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Don't Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action2)
        {
                    UIAlertController *myAlert2 = [UIAlertController alertControllerWithTitle:@"Alert" message:@"PPE wants to navigate on." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Amazon.in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         NSURL *buyUrl = [NSURL URLWithString:bookToShow.bookUrl];
                                         
                                         if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
                                         {
                                             [[UIApplication sharedApplication] openURL: buyUrl];
                                         }
                                     }];
            UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"Amazon.com" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                      {
                                          NSURL *buyUrl = [NSURL URLWithString:bookToShow.countryUrl];
                                          
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
            NSURL *buyUrl = [NSURL URLWithString:bookToShow.bookUrl];
            
            if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
            {
                [[UIApplication sharedApplication] openURL: buyUrl];
            }
        }
        else
        {
            NSURL *buyUrl = [NSURL URLWithString:bookToShow.countryUrl];
            
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
    if (code == kCLAuthorizationStatusNotDetermined && ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]))
    {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [_locationManager requestAlwaysAuthorization];
        }
        else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [_locationManager  requestWhenInUseAuthorization];
        }
        else {
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
                    NSURL *buyUrl = [NSURL URLWithString:bookToShow.bookUrl];
                    
                    if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
                    {
                        [[UIApplication sharedApplication] openURL: buyUrl];
                    }
                }
                else
                {
                    NSURL *buyUrl = [NSURL URLWithString:bookToShow.countryUrl];
                    
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

- (IBAction)menuBtnActn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)bookButtonAction:(id)sender
{
    Buy_BooksViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Buy_BooksViewController"];
    vc.book = bookToShow;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
