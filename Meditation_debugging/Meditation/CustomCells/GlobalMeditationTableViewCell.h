//
//  GlobalMeditationTableViewCell.h
//  Meditation
//
//  Created by IOS-01 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalMeditationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageBookmark;
@property (weak, nonatomic) IBOutlet UILabel *labelTimingAndDate;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfMeditators;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end
