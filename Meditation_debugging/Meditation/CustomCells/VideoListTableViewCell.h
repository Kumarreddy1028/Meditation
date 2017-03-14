//
//  VideoListTableViewCell.h
//  Meditation
//
//  Created by IOS1-2016 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface VideoListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblVideoDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *lblLike;
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UILabel *lblPublished;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end
