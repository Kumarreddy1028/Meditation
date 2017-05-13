//
//  GlobalMeditationViewController.h
//  Meditation
//
//  Created by IOS-01 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomMkAnnotationViewForGlobalMeditation.h"

typedef enum {
    rowLikeStateLike, //row is liked
    rowLikeStateUnlike, //row is unliked
} rowLikeState;

@interface GlobalMeditationViewController : UIViewController <MKMapViewDelegate, MKAnnotation>
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
- (IBAction)btnJoinActn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)btnMenuActn:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewOutlet;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *midView;

- (IBAction)pinBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *meditatorsCount;
@property (weak, nonatomic) IBOutlet UILabel *countries;
@property (weak, nonatomic) IBOutlet UILabel *istDateTime;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
- (IBAction)dashboardBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;

- (IBAction)infoBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dashboardBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleGlobalMeditation;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

@property (retain, nonatomic) NSMutableArray *upcomingMeditations, *pastMeditatiions, *dataArray;

@property (strong, nonatomic) CustomMkAnnotationViewForGlobalMeditation *customAnnotation;
@property (retain, nonatomic) NSMutableDictionary *responseDict;
-(void)serviceCallForGlobalMeditationJoin:(NSInteger) index;
-(void)serviceCallForGlobalMeditationUnJoin:(NSInteger) index;
-(void)serviceCallForLatLong;

@end
