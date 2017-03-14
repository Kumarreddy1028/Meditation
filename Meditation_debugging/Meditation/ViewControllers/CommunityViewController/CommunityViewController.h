//
//  CommunityViewController.h
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *communityView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtnActn;

- (IBAction)menuBtnActn:(id)sender;

@end
