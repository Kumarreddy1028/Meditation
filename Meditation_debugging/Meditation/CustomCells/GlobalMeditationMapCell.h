//
//  GlobalMeditationMapCell.h
//  Meditation
//
//  Created by Kumar on 02/05/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GlobalMeditationViewController.h"
@class GlobalMeditationMapCell;
@protocol GlobalMeditationMapCellDelegate <NSObject>

- (void)btnJoinActn:(UIButton *)sender;

@end

@interface GlobalMeditationMapCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
- (IBAction)btnJoinActn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)btnMenuActn:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewOutlet;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *midView;
- (IBAction)pinBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *meditatorsCount;
@property (weak, nonatomic) IBOutlet UILabel *countries;
@property (weak, nonatomic) IBOutlet UILabel *istDateTime;
@property (strong, nonatomic) NSMutableDictionary *respDict;
@property ( strong, nonatomic) GlobalMeditationViewController *viewcontroller;
- (void) configureCell;
@end
