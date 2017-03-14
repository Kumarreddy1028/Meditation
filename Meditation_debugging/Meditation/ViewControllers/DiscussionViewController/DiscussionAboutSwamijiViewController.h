//
//  DiscussionAboutSwamijiViewController.h
//  Meditation
//
//  Created by IOS1-2016 on 12/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    fetchDirectionUpward,
    fetchDirectionDownward,
} fetchDirection;

@interface DiscussionAboutSwamijiViewController : UIViewController

- (IBAction)backActionButton:(id)sender;
- (IBAction)discussionActionButton:(id)sender;
- (IBAction)tapGestureRecogniserAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLoadMore;
- (IBAction)loadMoreActionButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnDiscussion;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) NSString *pageTitle;
@property (strong, nonatomic) NSString *discussionId;


@end
