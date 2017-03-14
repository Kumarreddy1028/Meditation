//
//  GlobalMeditationPostTableViewCell.m
//  Meditation
//
//  Created by apple on 03/03/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import "GlobalMeditationPostTableViewCell.h"

@implementation GlobalMeditationPostTableViewCell
- (IBAction)onTapPlay:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(pastMeditationCellDidSelectPlay:)]) {
        [_delegate pastMeditationCellDidSelectPlay:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.playButton.layer.cornerRadius = 5;
//    self.playButton.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
