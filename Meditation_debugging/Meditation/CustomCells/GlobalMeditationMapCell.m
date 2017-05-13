//
//  GlobalMeditationMapCell.m
//  Meditation
//
//  Created by Kumar on 02/05/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import "GlobalMeditationMapCell.h"
#import "GlobalMeditationModelClass.h"
#import "GlobalMeditationModelClass.h"
#import "MeditationMusicViewController.h"
#import "CustomMkAnnotationViewForGlobalMeditation.h"
@interface GlobalMeditationMapCell()
{
    NSInteger locationIndex;
    NSMutableArray *dataArray;
    CLLocationCoordinate2D centerCoor;
    CLLocationDistance radius;
    NSMutableArray *latLongArray;
    BOOL isRegionWise, flag;
    NSDate *dateFromString;
    CLLocationCoordinate2D newCenter;
//    CLLocationCoordinate2D newCenter;
    int currentZoomLevel;

}
@end

@implementation GlobalMeditationMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.midView bringSubviewToFront:self];
    _btnJoin.layer.masksToBounds = NO;
    _btnJoin.layer.cornerRadius = 8; // if you like rounded corners
    _btnJoin.layer.shadowOffset = CGSizeMake(-1, -1);
    _btnJoin.layer.shadowRadius = 5;
    _btnJoin.layer.shadowOpacity = 0.5;
    
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.cornerRadius = 8; // if you like rounded corners
    _shadowView.layer.shadowOffset = CGSizeMake(-1, -1);
    _shadowView.layer.shadowRadius = 5;
    _shadowView.layer.shadowOpacity = 0.5;
    
    
//    self.mapViewOutlet.layer.masksToBounds = NO;
//    self.mapViewOutlet.layer.cornerRadius = 8; // if you like rounded corners
//    self.mapViewOutlet.layer.shadowOffset = CGSizeMake(-1, -1);
//    self.mapViewOutlet.layer.shadowRadius = 5;
//    self.mapViewOutlet.layer.shadowOpacity = 0.5;
//    
//    
//    self.midView.layer.masksToBounds = NO;
//    self.midView.layer.cornerRadius = 8; // if you like rounded corners
//    self.midView.layer.shadowOffset = CGSizeMake(-1, -1);
//    self.midView.layer.shadowRadius = 5;
//    self.midView.layer.shadowOpacity = 0.5;
    
    
    
//    [self setBackgroundColor:[UIColor blackColor]];
    // Initialization code
//    CLLocationCoordinate2D center=CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] doubleValue], [[dict objectForKey:@"longitude"] doubleValue]);
//    CustomMkAnnotationViewForGlobalMeditation *customAnnotation1=[[CustomMkAnnotationViewForGlobalMeditation alloc]initWithTitle:@"" Location:center];
//    
//
//    
//    [self.mapViewOutlet addAnnotation:self.viewcontroller.customAnnotation];
    //[self setLatestTopicDetails];

    
}

- (void) configureCell {
    self.mapViewOutlet.showsUserLocation = YES;
    
    [self.mapViewOutlet setMapType:MKMapTypeStandard];
    [self.mapViewOutlet setZoomEnabled:YES];
    [self.mapViewOutlet setScrollEnabled:YES];
    [self.mapViewOutlet setCenterCoordinate:self.mapViewOutlet.userLocation.location.coordinate animated:YES];
    [self addRegionOnMap:self.respDict];
    
    
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.title = @"The title";
    ann.subtitle = @"A subtitle";
    ann.coordinate = CLLocationCoordinate2DMake (60.123456, 10.123456);
    [self.mapViewOutlet addAnnotation:ann];
    [self.mapViewOutlet setShowsUserLocation:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)addRegionOnMap:(NSDictionary *)response
{
    latLongArray = [[NSMutableArray alloc] init];
    latLongArray=[response objectForKey:@"latlong"];
    if ([[response objectForKey:@"region_wise"] isEqualToString:@"0"])
    {
        isRegionWise = NO;
    } 
    else
        isRegionWise = YES;
    
    if(isRegionWise)
    {
        
        if (latLongArray.count >0)
        {
            NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            latLongArray = [NSMutableArray arrayWithArray:[latLongArray sortedArrayUsingDescriptors:sortDescriptors]];
            if (isRegionWise)
            {
                for (int i = 0; i < latLongArray.count; i++)
                {
                    
                    NSLog(@"hello = %lu",(unsigned long)latLongArray.count);
                    NSDictionary *dict = [latLongArray objectAtIndex:i];
                    if ([[dict objectForKey:@"count"] integerValue] == 0)
                    {
                        [latLongArray removeObject:dict];
                        i = 0;
                    }
                }
            }
            
            for (NSDictionary *dict in latLongArray)
            {
                CLLocationCoordinate2D center=CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] doubleValue], [[dict objectForKey:@"longitude"] doubleValue]);
                CustomMkAnnotationViewForGlobalMeditation *customAnnotation1=[[CustomMkAnnotationViewForGlobalMeditation alloc]initWithTitle:@"" Location:center];
                
                [self.mapViewOutlet addAnnotation:customAnnotation1];
                
            }
        }
    }
    else
    {
        for (NSDictionary *dict in latLongArray)
        {
            CLLocationCoordinate2D center=CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] doubleValue], [[dict objectForKey:@"longitude"] doubleValue]);
            CustomMkAnnotationViewForGlobalMeditation *customAnnotation1=[[CustomMkAnnotationViewForGlobalMeditation alloc]initWithTitle:@"" Location:center];
            
            [self.mapViewOutlet addAnnotation:customAnnotation1];
        }
    }
    [self setLatestTopicDetails];
}


- (IBAction)pinBtnActn:(id)sender
{
    UIButton *button = sender;
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn)
    {
        GlobalMeditationModelClass *obj = [self.viewcontroller.upcomingMeditations objectAtIndex:button.tag];
        if (![obj.isJoined isEqualToString:@"already joined"])
        {
            [self changeRowLikeStateTo:rowLikeStateLike ofRowWithTopicId:obj andButton:button];
        }
        else
        {
            [self changeRowLikeStateTo:rowLikeStateUnlike ofRowWithTopicId:obj andButton:button];
        }
    }
    else
    {
        //user is not logged in.
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Sign-in required" message:@"Please sign-in to join this global event." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"Sign-in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           UIViewController *signInController =[self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                           [self.viewcontroller presentViewController:signInController animated:YES completion:nil];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:signInAction];
        [myAlert addAction:cancelAction];
        [self.viewcontroller presentViewController:myAlert animated:YES completion:nil];
        
    }
}

-(void)changeRowLikeStateTo:(rowLikeState)LikeState ofRowWithTopicId:(GlobalMeditationModelClass *)topic andButton:(UIButton *)button
{
    UIImage *imageToBeSet;
    NSMutableDictionary *dict;
    NSString *country =[Utility sharedInstance].country;
    if ([country isKindOfClass:[NSNull class]] || country == nil) {
        country = @"";
    }
    switch (LikeState)
    {
            
        case rowLikeStateLike:
        {
            dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"SERVICE_USER_GLOBAL_MEDITATION_REGISTRATION" forKey:@"REQUEST_TYPE_SENT"];
            [dict setObject:[Utility userId] forKey:User_Id];
            [dict setObject:topic.topicId forKey:@"topic_id"];
            [dict setObject:[NSString stringWithFormat:@"%f",[Utility sharedInstance].annotationCoord.latitude] forKey:@"latitude"];
            [dict setObject:[NSString stringWithFormat:@"                           %f",[Utility sharedInstance].annotationCoord.longitude] forKey:@"longitude"];
            [dict setObject:country forKey:@"country"];
            
            imageToBeSet = [UIImage imageNamed:@"pin_select"];
        }
            break;
        case rowLikeStateUnlike:
        {
            dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"SERVICE_USER_GLOBAL_MEDITATION_UNREGISTRATION" forKey:@"REQUEST_TYPE_SENT"];
            [dict setObject:[Utility userId] forKey:User_Id];
            [dict setObject:topic.topicId forKey:@"topic_id"];
            [dict setObject:@"2" forKey:@"device_type"];
            [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
            imageToBeSet = [UIImage imageNamed:@"pin_unselect"];
        }
            break;
            
        default:
            break;
    }
    
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
      { if ([responseObject isKindOfClass:[NSDictionary class]])
      {
          responseObject = [Utility convertDictionaryIntoUTF8:[responseObject allValues] dictionary:responseObject];
      }
          [SVProgressHUD dismiss];
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                  
              }
              else
              {
                  if ([responseObject objectForKey:@"error_code"])
                  {
                      NSString *err=[responseObject objectForKey:@"error_desc"];
                      [self.viewcontroller.view makeToast:err];
                      NSLog(@"Error: %@", err);
                  }
                  else if ([responseObject isKindOfClass:[NSDictionary class]])
                  {
                      [button setImage:imageToBeSet forState:UIControlStateNormal];
                      switch (LikeState)
                      {
                          case rowLikeStateLike:
                          {
                              [self.viewcontroller.view makeToast:@"You have joined this meditation"];
                          }
                              break;
                          case rowLikeStateUnlike:
                          {
                              [self.viewcontroller.view makeToast:@"You have left this meditation"];
                          }
                              break;
                              
                          default:
                              break;
                      }
                      //[self.viewcontroller serviceCallForGlobalMeditation];
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
    
}


- (void)setLatestTopicDetails
{
    NSString *str;
    GlobalMeditationModelClass *obj=[self.viewcontroller.upcomingMeditations firstObject];
    if (!obj) {
        if ([self.viewcontroller.pastMeditatiions count]) {
            obj = [self.viewcontroller.pastMeditatiions lastObject];
        }
    }
    if (obj == nil) {
        return;
    }
    if ([obj.isJoined isEqualToString:@"already joined"])
    {
        [self.btnJoin setTitle:@"unjoin" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnJoin setTitle:@"join" forState:UIControlStateNormal];
    }
    
    //    NSDate *dateNew = [Utility getDateFromString:obj.duration];
    //    NSDate *startDate = [NSDate dateWithTimeInterval:<#(NSTimeInterval)#> sinceDate:<#(nonnull NSDate *)#>]
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *dateFromAString = [dateFormatter dateFromString:obj.startDate];
    
    NSString *remainingDuration = [Utility remaningTime:[NSDate date] endDate:dateFromAString];
    
    NSLog(@"strings remaining duration %@", remainingDuration);
    str = [Utility timeDifference:[NSDate date] ToDate:obj.startDate];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter1.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *startingdate = [dateFormatter1 dateFromString:obj.startDate];
    
    NSTimeInterval duration = [Utility totalDurationFromString:obj.duration];
    
    NSDate *finishedDate = [startingdate dateByAddingTimeInterval:duration];
    NSDate *CurrentDate = [NSDate date];
    NSLog(@"difference %f",[Utility getTimeDifference:obj.startDate]);
    //[self timeUpdate];
    
    
    
    
    
    if (([startingdate compare:CurrentDate] == NSOrderedDescending) && (![obj isEqual:[self.viewcontroller.pastMeditatiions lastObject]])) {
        if ([obj.isJoined isEqualToString:@"already joined"])
        {
            [self.btnJoin setTitle:@"unjoin" forState:UIControlStateNormal];
        }
        else
        {
            [self.btnJoin setTitle:@"join" forState:UIControlStateNormal];
        }
        str=[Utility timeDifference:[NSDate date] ToDate:obj.startDate];
        self.timeLeft.text=[Utility changeTimeformat:str];
        //[myTimer invalidate];
    } else if ( ( [startingdate compare:CurrentDate] == NSOrderedAscending) && ([finishedDate compare:CurrentDate] == NSOrderedDescending) ) {
        NSLog(@"finishedDate1 is later than CurrentDate");
        self.timeLeft.text=@"started";
        [self.btnJoin setTitle:@"Begin" forState:UIControlStateNormal];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSString *currentDateString = [Utility getUTCFormateDate:[NSDate date]];
        NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
        NSDate *startDt = [obj.startDt dateByAddingTimeInterval:[Utility totalDurationFromString:obj.duration]];
        NSTimeInterval duration = 0 - [currentDate timeIntervalSinceDate:obj.startDt];
        NSLog(@"duration %fl, Cduration %@", duration, obj.duration);
        int timeToleave = [Utility totalDurationFromString:obj.duration];
        NSLog(@"Timetoleave1 %d", timeToleave);
        [self performSelector:@selector(removeUpdatedMediation:) withObject:obj afterDelay:duration];
        
        
    }
    if ([finishedDate compare:CurrentDate] == NSOrderedAscending) {
        if ([obj isEqual:[self.viewcontroller.pastMeditatiions lastObject]]) {
            NSLog(@"finishedDate is earlier than CurrentDate");
            self.timeLeft.text=@"Finished";
            [self.btnJoin setTitle:@"Finished" forState:UIControlStateNormal];
            GlobalMeditationModelClass *obj=[self.viewcontroller.dataArray objectAtIndex:0];
            str=[Utility timeDifference:[NSDate date] ToDate:obj.startDate];
            self.timeLeft.text=[Utility changeTimeformat:str];
            [[Utility sharedInstance] setIsFinished:TRUE];
        }
    }
    
    
    
    [self.countries setText:obj.countries];
    [self.meditatorsCount setText:[[Utility sharedInstance] convertNumberIntoDepiction:obj.meditators]];
    
    NSString *inDateStr = obj.startDate;
    
    NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
    outDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    outDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *outDate = [outDateFormatter dateFromString:inDateStr];
    [outDateFormatter setDateFormat:@"dd MMM, hh:mma"];
    outDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    NSString *stringDate = [outDateFormatter stringFromDate:outDate];
    
    stringDate=[[[NSString stringWithFormat:@"(%@ )",stringDate]stringByReplacingOccurrencesOfString:@"AM" withString:@"am"]stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    
    [self.istDateTime setText:stringDate];
    
}



- (IBAction)btnJoinActn:(UIButton *)sender
{
    return;
    
    [self.viewcontroller btnJoinActn:sender];
    
    if ([sender titleForState:UIControlStateNormal] == nil) {
        return;
    }
    //    GlobalMeditationModelClass *currentTopic = [dataArray objectAtIndex:0];
    //
    //    MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
    //    cont.musicName=currentTopic.musicFileName;
    //    cont.imageName=currentTopic.musicImageName;
    //
    //    NSString *str=currentTopic.duration;
    //    cont.duration=@"00:05:20";
    
    //    cont.meditators = currentTopic.meditators;
    //    cont.countries = currentTopic.countries;
    //    [self.navigationController pushViewController:cont animated:YES];
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    
    if (loggedIn)
    {
        NSInteger index = 0;
        if (sender.tag != -1) {
            index = sender.tag;
        }
        GlobalMeditationModelClass *currentTopic = [self.viewcontroller.upcomingMeditations objectAtIndex:index];
        if ([self.btnJoin.titleLabel.text isEqualToString:@"Begin"])
        {
            if ([currentTopic.isJoined isEqualToString:@"already joined"])
            {//user has joined.
                
                MeditationMusicViewController *cont=[self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
                if ([currentTopic.musicFileName isEqualToString:@""])
                {
                    cont.musicName=currentTopic.musicfilemp3;
                }
                else
                {
                    cont.musicName=currentTopic.musicFileName;
                }
                cont.global = YES;
                cont.color=currentTopic.colorCode;
                cont.imageName=currentTopic.musicImageName;
                cont.duration=currentTopic.duration;
                //                    cont.meditators = currentTopic.meditators;
                //                    cont.countries = currentTopic.countries;
                [self.viewcontroller.navigationController pushViewController:cont animated:YES];
            }
            else
            {
                //                    NSString *string = @"You haven’t joined this meditation.";
                //                    [self.view makeToast:string];
                [self.viewcontroller serviceCallForGlobalMeditationJoin:index];
                MeditationMusicViewController *cont=[self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
                if ([currentTopic.musicFileName isEqualToString:@""])
                {
                    cont.musicName=currentTopic.musicfilemp3;
                }
                else
                {
                    cont.musicName=currentTopic.musicFileName;
                }
                cont.global = YES;
                cont.color=currentTopic.colorCode;
                cont.imageName=currentTopic.musicImageName;
                cont.duration=currentTopic.duration;
                //                    cont.meditators = currentTopic.meditators;
                //                    cont.countries = currentTopic.countries;
                [self.viewcontroller.navigationController pushViewController:cont animated:YES];
                
            }
            
        }
        else
        {
            if ([currentTopic.isJoined isEqualToString:@"already joined"])
            {//user has joined.
                [self.viewcontroller serviceCallForGlobalMeditationUnJoin:index];
            }
            else
            {
                [self.viewcontroller serviceCallForGlobalMeditationJoin:index];
            }
            
        }
    }
    else
    {
        //user is not logged in.
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Sign-in required" message:@"Please sign-in to join this meditation." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"Sign-in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           UIViewController *signInController =[self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                           [self.viewcontroller presentViewController:signInController animated:YES completion:nil];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:signInAction];
        [myAlert addAction:cancelAction];
        [self.viewcontroller presentViewController:myAlert animated:YES completion:nil];
    }
}



#pragma mark-MapView Delegate methods-


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        self.mapViewOutlet.showsUserLocation=YES;
        return nil;
    }
    else if ([annotation isKindOfClass:[CustomMkAnnotationViewForGlobalMeditation class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"myPin";
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        CGRect frame = annotationView.frame;
        if ([latLongArray count] && locationIndex < latLongArray.count)
        {
            NSDictionary *dict = [latLongArray objectAtIndex:locationIndex];
            
            float highestUserCount = [[[latLongArray firstObject] objectForKey:@"count"] floatValue];
            if (isRegionWise)
            {
                if (highestUserCount <= 10)
                {
                    frame.size=CGSizeMake(10, 10);
                }
                else
                {
                    CGFloat size = ([[dict objectForKey:@"count"] integerValue]/highestUserCount)*25.0;
                    frame.size = CGSizeMake(size, size);
                }
            }
            else
            {
                frame.size = CGSizeMake(10, 10);
            }
        }
        annotationView.frame = frame;
        annotationView.layer.cornerRadius = annotationView.frame.size.width/2;
        annotationView.canShowCallout = NO;
        [annotationView setBackgroundColor:[UIColor greenColor]];
        locationIndex++;
        self.mapViewOutlet.showsUserLocation=YES;
        return annotationView;
    }
    return nil;
}
- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views)
    {
        if ([[view annotation] isKindOfClass:[MKUserLocation class]])
        {
            [[view superview] bringSubviewToFront:view];
        }
        else
        {
            [[view superview] sendSubviewToBack:view];
        }
    }
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    for (NSObject *annotation in [mapView annotations])
    {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            NSLog(@"Bring blue location dot to front");
            MKAnnotationView *view = [mapView viewForAnnotation:(MKUserLocation *)annotation];
            [[view superview] bringSubviewToFront:view];
        }
    }
    //centerCoor = [self getCenterCoordinate];
    radius = [self getRadius];
    
    
    
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
    CLLocation *newLoc = [[CLLocation alloc] initWithLatitude:newCenter.latitude longitude:newCenter.longitude];
    
    CLLocationDistance itemDist = [newLoc distanceFromLocation:currentLoc]/1000;
    
    //    if (!flag)
    //    {
    //       currentZoomLevel=40 - [self getZoomLevel];
    //        flag = YES;
    //    }
    currentZoomLevel=40 - [self getZoomLevel];
    
    
    //    if (currentZoomLevel >= 16)
    //    {
    //        currentZoomLevel--;
    //    }
    //    else if (currentZoomLevel < 16)
    //    {
    //        currentZoomLevel++;
    //    }
    // int x=pow(2, currentZoomLevel/2);
    if (itemDist >=currentZoomLevel * 20)
    {
        [mapView removeAnnotations:mapView.annotations];
        
        [self.viewcontroller serviceCallForLatLong];
        newCenter = [self getCenterCoordinate];
    }
    else if(currentZoomLevel < 16 && currentZoomLevel > 10)
    {
        if (itemDist > currentZoomLevel/2)
        {
            [mapView removeAnnotations:mapView.annotations];
            
            [self.viewcontroller serviceCallForLatLong];
            newCenter = [self getCenterCoordinate];
            
        }
    }
    else if(currentZoomLevel <= 10 && currentZoomLevel >= 5)
    {
        if (itemDist > currentZoomLevel/4)
        {
            [mapView removeAnnotations:mapView.annotations];
            
            [self.viewcontroller serviceCallForLatLong];
            newCenter = [self getCenterCoordinate];
            
        }
    }
    else if(currentZoomLevel < 5)
    {
        [mapView removeAnnotations:mapView.annotations];
        
        [self.viewcontroller serviceCallForLatLong];
        newCenter = [self getCenterCoordinate];
        
    }
    else
        newCenter=centerCoor;
}

- (CLLocationDistance)getRadius
{
    centerCoor = [self getCenterCoordinate];
    // init center location from center coordinate
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
    
    CLLocationCoordinate2D topCenterCoor = [self getTopCenterCoordinate];
    CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:topCenterCoor.latitude longitude:topCenterCoor.longitude];
    
    radius = [centerLocation distanceFromLocation:topCenterLocation];
    radius = radius/1000.0;
    return radius;
}

- (CLLocationCoordinate2D)getCenterCoordinate
{
    CLLocationCoordinate2D center = [self.mapViewOutlet centerCoordinate];
    return center;
}

- (CLLocationCoordinate2D)getTopCenterCoordinate
{
    // to get coordinate from CGPoint of your map
    CLLocationCoordinate2D topCenterCoor = [self.mapViewOutlet convertPoint:CGPointMake(self.mapViewOutlet.frame.size.width / 2.0f, 0) toCoordinateFromView:self.mapViewOutlet];
    return topCenterCoor;
}
//
//#define MERCATOR_RADIUS 85445659.44705395
//#define MAX_GOOGLE_LEVELS 20
//
//@interface MKMapView (ZoomLevel)
//- (double)getZoomLevel;
//@end
//
//@implementation MKMapView (ZoomLevel)
//
- (double)getZoomLevel
{
    
    //  MKCoordinateRegion region;
    // CLLocationDegrees longitudeDelta =region.span.longitudeDelta;
    CLLocationDegrees longitudeDelta =1;
    CGFloat mapWidthInPixels = self.mapViewOutlet.bounds.size.width;
    double zoomScale = longitudeDelta * [self getRadius] * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = 20 - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}




@end
