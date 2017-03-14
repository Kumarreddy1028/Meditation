//
//  GlobalMeditationPostTableViewCell.h
//  Meditation
//
//  Created by apple on 03/03/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalMeditationPostTableViewCell;
@protocol GlobalMeditationPostTableViewCellDelegate <NSObject>

- (void)pastMeditationCellDidSelectPlay:(GlobalMeditationPostTableViewCell *)cell;

@end

@interface GlobalMeditationPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTimingAndDate;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfMeditators;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, weak) id <GlobalMeditationPostTableViewCellDelegate> delegate;
@end
