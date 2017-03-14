//
//  CommunityTableViewCell.h
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUpcomingEvents;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscussion;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *labelEndOn;

@end
