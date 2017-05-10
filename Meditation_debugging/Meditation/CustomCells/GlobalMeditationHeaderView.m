//
//  GlobalMeditationHeaderView.m
//  Meditation
//
//  Created by apple on 03/03/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import "GlobalMeditationHeaderView.h"

@interface GlobalMeditationHeaderView () {
    
    __weak IBOutlet UIButton *_arrowButton;
    __weak IBOutlet UILabel *_titleLabel;
}

@end

@implementation GlobalMeditationHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tapGest];
}

- (void)setType:(GlobalMeditationHeaderViewType)type {
    _type = type;
    NSString *titleString = type == GlobalMeditationHeaderViewTypeUpcomming ? @"current schedule" : @"past meditations";
    _titleLabel.text = titleString;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){

    } else {
        [_titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.0f]];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = _isSelected;
    _arrowButton.selected = isSelected;
}

- (void)onTap {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedHeader:type:)]) {
        [_delegate didSelectedHeader:self type:_type];
    }
}

@end
