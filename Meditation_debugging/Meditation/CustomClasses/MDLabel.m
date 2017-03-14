//
//  MDLabel.m
//  Meditation
//
//  Created by apple on 24/02/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import "MDLabel.h"

@implementation MDLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIEdgeInsets insets = {0, _leftPading, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
