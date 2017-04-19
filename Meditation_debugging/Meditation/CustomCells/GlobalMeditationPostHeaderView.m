//
//  GlobalMeditationHeaderView.m
//  Meditation
//
//  Created by apple on 03/03/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import "GlobalMeditationPostHeaderView.h"
#import "GlobalMeditationHeaderView.h"

@interface GlobalMeditationPostHeaderView () {
    
    __weak IBOutlet UIButton *_arrowButton;
    __weak IBOutlet UILabel *_titleLabel;
}

@end

@implementation GlobalMeditationPostHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
//        [_titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:60.0f]];
//    }
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        [_titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:30.0f]];
        
    }
    else {
        [_titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.0f]];
    }
	    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tapGest];
    
}

- (void)setType:(GlobalMeditationPostHeaderViewType)type {
//    _type = type;
//    NSString *titleString = type == GlobalMeditationHeaderViewTypeUpcomming ? @"   upcoming meditation schedule" : @"   past meditations";
//    _titleLabel.text = titleString;
    
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = _isSelected;
    _arrowButton.selected = isSelected;
}

- (void)onTap {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedHeader:type:)]) {
//        [_delegate didSelectedHeader:self type:_type];
    }
}

@end
