//
//  GlobalMeditationTableViewCell.m
//  Meditation
//
//  Created by IOS-01 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "GlobalMeditationTableViewCell.h"

@implementation GlobalMeditationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.joinBtn.layer.cornerRadius = 5;
    self.joinBtn.clipsToBounds = YES;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
