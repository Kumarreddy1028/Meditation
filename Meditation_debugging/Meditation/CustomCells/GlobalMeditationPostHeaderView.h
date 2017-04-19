//
//  GlobalMeditationPostHeaderView.h
//  Meditation
//
//  Created by apple on 03/03/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GlobalMeditationPostHeaderViewTypeUpcomming,
    GlobalMeditationPostHeaderViewTypePast
}GlobalMeditationPostHeaderViewType;

@class GlobalMeditationPostHeaderView;
@protocol GlobalMeditationPostHeaderViewDelegate <NSObject>

//- (void)didSelectedHeader:(GlobalMeditationPostHeaderView *)view type:(GlobalMeditationHeaderViewType)type;

@end

@interface GlobalMeditationPostHeaderView : UITableViewHeaderFooterView {
    
}
@property (nonatomic) BOOL isSelected;
@property (nonatomic) GlobalMeditationPostHeaderViewType type;
@property (nonatomic, weak) id <GlobalMeditationPostHeaderViewDelegate> delegate;
@end
