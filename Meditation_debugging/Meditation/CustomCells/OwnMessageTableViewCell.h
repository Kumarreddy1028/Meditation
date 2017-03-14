//
//  OwnMessageTableViewCell.h
//  Meditation
//
//  Created by IOS1-2016 on 12/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblId;
@property (weak, nonatomic) IBOutlet UIView *paddingView;

@end
