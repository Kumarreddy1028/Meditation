//
//  MeditationProgressViewController.m
//  Meditation
//
//  Created by IOS-01 on 16/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "MeditationProgressViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomMkAnnotationViewForGlobalMeditation.h"
#import "SVPulsingAnnotationView.h"

@interface MeditationProgressViewController ()<MKMapViewDelegate>
{
CMTime currentPlayTime;
    bool stop,paused;
    CLLocationCoordinate2D centerCoor;
    CLLocationDistance radius;
    NSMutableArray *latLongArray;
    NSInteger locationIndex;
    BOOL isRegionWise;
    NSDate *dateFromString;
    CLLocationCoordinate2D newCenter;
    int currentZoomLevel;

}
@end

@implementation MeditationProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.musicImage sd_setImageWithURL:[NSURL URLWithString:self.imageName] placeholderImage:[UIImage imageNamed:@"placeholder"]];
   
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];
    self.mapView.delegate=self;
    self.lblCountries.text = self.countries;
    self.lblMeditators.text = self.meditators;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playBtnActn:(id)sender
{
    if ([self.playBtn isSelected])
    {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];
        [self.playBtn setSelected:NO];
        [self.songPlayer pause];
        if (!stop)
        {
            currentPlayTime = self.songPlayer.currentTime;
            paused =YES;
            
        }
        
        
    }
    else
    {
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected | UIControlStateHighlighted];

        self.songPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:self.musicName]];
        if (paused)
        {
            paused = NO;
            [self.songPlayer seekToTime:currentPlayTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        }
        [self.songPlayer play];
        [self.playBtn  setSelected:YES];
        
        
    }
}

- (IBAction)backBtnActn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)serviceCallForLatLong
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_GET_LAT_LONG" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[NSString stringWithFormat:@"%f",centerCoor.latitude] forKey:@"latitude"];
    [dict setObject:[NSString stringWithFormat:@"%f",centerCoor.longitude] forKey:@"longitude"];
    [dict setObject:[NSString stringWithFormat:@"%f",radius] forKey:@"raidus"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:@"5345" forKey:@"device_token"];
    
    [SVProgressHUD show];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          [SVProgressHUD dismiss];
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                  NSLog(@"blank Array");
              }
              else
              {
                  if ([responseObject objectForKey:@"error_code"])
                  {
                      NSString *err=[responseObject objectForKey:@"error_desc"];
                      [self.view makeToast:err];
                      NSLog(@"Error: %@", err);
                  }
                  else if ([responseObject isKindOfClass:[NSDictionary class]])
                  {
                      locationIndex = 0;
                      [self addRegionOnMap:responseObject];
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
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
                CustomMkAnnotationViewForGlobalMeditation *customAnnotation=[[CustomMkAnnotationViewForGlobalMeditation alloc]initWithTitle:@"" Location:center];
                
                [self.mapView addAnnotation:customAnnotation];
            }
        }
    }
    else
    {
        for (NSDictionary *dict in latLongArray)
        {
            CLLocationCoordinate2D center=CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] doubleValue], [[dict objectForKey:@"longitude"] doubleValue]);
            CustomMkAnnotationViewForGlobalMeditation *customAnnotation=[[CustomMkAnnotationViewForGlobalMeditation alloc]initWithTitle:@"" Location:center];
            
            [self.mapView addAnnotation:customAnnotation];
        }
    }
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[CustomMkAnnotationViewForGlobalMeditation class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"myPin";
        
        SVPulsingAnnotationView *annotationView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        CGRect frame = annotationView.frame;
        if ([latLongArray count] && locationIndex < latLongArray.count)
        {
            NSDictionary *dict = [latLongArray objectAtIndex:locationIndex];
            
            NSInteger highestUserCount = [[[latLongArray firstObject] objectForKey:@"count"] integerValue];
            if (isRegionWise)
            {
                if (highestUserCount <= 10)
                {
                    frame.size=CGSizeMake(10, 10);
                }
                else
                {
                    NSInteger size = ([[dict objectForKey:@"count"] integerValue]/highestUserCount)*40;
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
            annotationView.canShowCallout = YES;
            [annotationView setBackgroundColor:[UIColor greenColor]];
            annotationView.annotationColor = [UIColor greenColor];

            locationIndex++;
            
            return annotationView;
        
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    radius = [self getRadius];
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
    CLLocation *newLoc = [[CLLocation alloc] initWithLatitude:newCenter.latitude longitude:newCenter.longitude];
    CLLocationDistance itemDist = [newLoc distanceFromLocation:currentLoc]/1000;
    currentZoomLevel=40 - [self getZoomLevel];

    if (itemDist >=currentZoomLevel * 20)
    {
        [mapView removeAnnotations:mapView.annotations];
        
        [self serviceCallForLatLong];
        newCenter = [self getCenterCoordinate];
    }
    else if(currentZoomLevel < 16 && currentZoomLevel > 10)
    {
        if (itemDist > currentZoomLevel/2)
        {
            [mapView removeAnnotations:mapView.annotations];
            
            [self serviceCallForLatLong];
            newCenter = [self getCenterCoordinate];
            
        }
    }
    else if(currentZoomLevel <= 10 && currentZoomLevel >= 5)
    {
        if (itemDist > currentZoomLevel/4)
        {
            [mapView removeAnnotations:mapView.annotations];
            
            [self serviceCallForLatLong];
            newCenter = [self getCenterCoordinate];
            
        }
    }
    else if(currentZoomLevel < 5)
    {
        [mapView removeAnnotations:mapView.annotations];
        
        [self serviceCallForLatLong];
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
    CLLocationCoordinate2D center = [self.mapView centerCoordinate];
    return center;
}

- (CLLocationCoordinate2D)getTopCenterCoordinate
{
    // to get coordinate from CGPoint of your map
    CLLocationCoordinate2D topCenterCoor = [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width / 2.0f, 0) toCoordinateFromView:self.mapView];
    return topCenterCoor;
}

- (double)getZoomLevel
{
    
    //  MKCoordinateRegion region;
    // CLLocationDegrees longitudeDelta =region.span.longitudeDelta;
    CLLocationDegrees longitudeDelta =1;
    CGFloat mapWidthInPixels = self.mapView.bounds.size.width;
    double zoomScale = longitudeDelta * [self getRadius] * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = 20 - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}


@end
