//
//  DashboardViewController.h
//  Meditation
//
//  Created by IOS-01 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface DashboardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property ( nonatomic ) BOOL noAnimation;
@property (strong, nonatomic) SKView *skview;
- (IBAction)metuBtnActn:(id)sender;
- (IBAction)infoBtnActn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (IBAction)closeButtonActn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *navigationImg;
@property (weak, nonatomic) IBOutlet UILabel *onlineUsers;
@property (weak, nonatomic) IBOutlet UIImageView *onlineUserCount;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
-(BOOL) checkforinfoview :(UITouch *) touch;
- (void)actionOnNode:(NSString *)nodeName;
@end
