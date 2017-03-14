//
//  MeditateNowIpadViewController.h
//  Meditation
//
//  Created by apple on 13/04/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    rowLikeStateLike, //row is liked
    rowLikeStateUnlike, //row is unliked
}rowLikeState;
@interface MeditateNowIpadViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBtnTrailling;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,strong)AVPlayer * songPlayer;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UIButton *guidedbtn;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleMeditateNow;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *dashboardBtn;

- (IBAction)menuBtnActn:(id)sender;
- (IBAction)startBtnAction:(UIButton *)sender;
- (IBAction)guidedBtnActn:(UIButton *)sender;
- (IBAction)musicBtnActn:(UIButton *)sender;
- (IBAction)previewBtnActn:(UIButton*)sender;
- (IBAction)dashboardBtnActn:(id)sender;
- (IBAction)closeBtnActn:(id)sender;
- (IBAction)infoBtnActn:(id)sender;

@end
