//
//  GlobalMeditationViewController.h
//  Meditation
//
//  Created by IOS-01 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    rowLikeStateLike, //row is liked
    rowLikeStateUnlike, //row is unliked
} rowLikeState;
@interface MeditationNowViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)AVPlayer * songPlayer;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)menuBtnActn:(id)sender;
- (IBAction)dashboardBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dashboardBtn;

- (IBAction)infoBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)closleBtnActn:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UILabel *titleMeditateNow;

@end
