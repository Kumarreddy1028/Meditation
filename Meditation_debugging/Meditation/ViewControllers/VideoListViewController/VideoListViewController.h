//
//  VideoListViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//


//#define playerView_Height_devider 6
//#define playerView_Height_adder 100
//#define playerView_animation_duration 0.5
#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

//typedef enum {
//    playerViewStateClosed, //playerView is closed
//    playerViewStateOpen, //playerView is open
//} playerViewState;

typedef enum {
    videoLikeStateLike, //video is liked
    videoLikeStateUnlike, //video is unliked
} videoLikeState;

@interface VideoListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (nonatomic) CGFloat previousContentoffset;
@property (nonatomic) CGFloat initialContentOffset;
@property (nonatomic) CGFloat playerViewMaxHeight;
@property (nonatomic) CGFloat playerViewMinHeight;
//@property (nonatomic, assign) playerViewState playerViewState;
-(void)initializeVideoInfoModel;
- (IBAction)backActionButton:(id)sender;
//@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

- (IBAction)dashboardBtnActn:(id)sender;

@end
