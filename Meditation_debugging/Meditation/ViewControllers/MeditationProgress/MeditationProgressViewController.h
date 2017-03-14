//
//  MeditationProgressViewController.h
//  Meditation
//
//  Created by IOS-01 on 16/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>

@interface MeditationProgressViewController : UIViewController
- (IBAction)playBtnActn:(id)sender;
- (IBAction)backBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblCountries;
@property (weak, nonatomic) IBOutlet UILabel *lblMeditators;
@property(nonatomic,strong)NSString * imageName;
@property(nonatomic,strong)NSString * musicName;
@property(nonatomic,strong)NSString * countries;
@property(nonatomic,strong)NSString * meditators;
@property(nonatomic,strong)AVPlayer * songPlayer;
@end
