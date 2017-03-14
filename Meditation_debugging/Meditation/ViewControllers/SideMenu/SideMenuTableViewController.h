//
//  SideMenuTableViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 08/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileName;
@property (weak, nonatomic) IBOutlet UILabel *onlineUsers;

@end
