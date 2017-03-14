//
//  MeditateNowIpadCell.h
//  Meditation
//
//  Created by apple on 14/04/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeditateNowIpadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMeditationTopic;
@property (weak, nonatomic) IBOutlet UILabel *lblUserLikes;
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (weak, nonatomic) IBOutlet UIView *selectedView;

@end
