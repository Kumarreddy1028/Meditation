//
//  MeditatorsViewController.h
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeditatorsViewController : UIViewController

@property (strong, nonatomic) NSString *discussionId;

- (IBAction)backBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
