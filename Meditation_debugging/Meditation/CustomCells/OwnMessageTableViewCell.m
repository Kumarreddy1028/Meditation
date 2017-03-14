//
//  OwnMessageTableViewCell.m
//  Meditation
//
//  Created by IOS1-2016 on 12/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "OwnMessageTableViewCell.h"

@implementation OwnMessageTableViewCell

- (void)awakeFromNib
{
    self.paddingView.layer.cornerRadius = 3;
    self.paddingView.clipsToBounds = YES;
    self.paddingView.layer.borderColor = [UIColor colorWithRed:255.0/255 green:165.0/255 blue:0.0/255 alpha:1.0].CGColor;
    self.paddingView.layer.borderWidth=3.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
