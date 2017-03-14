//
//  GlobalMeditationHeaderView.h
//  Meditation
//
//  Created by apple on 03/03/17.
//  Copyright © 2017 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GlobalMeditationHeaderViewTypeUpcomming,
    GlobalMeditationHeaderViewTypePast
}GlobalMeditationHeaderViewType;

@class GlobalMeditationHeaderView;
@protocol GlobalMeditationHeaderViewDelegate <NSObject>

- (void)didSelectedHeader:(GlobalMeditationHeaderView *)view type:(GlobalMeditationHeaderViewType)type;

@end

@interface GlobalMeditationHeaderView : UITableViewHeaderFooterView {
    
}
@property (nonatomic) BOOL isSelected;
@property (nonatomic) GlobalMeditationHeaderViewType type;
@property (nonatomic, weak) id <GlobalMeditationHeaderViewDelegate> delegate;
@end
