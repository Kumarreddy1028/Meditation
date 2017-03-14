//
//  MeditationMusicViewController.h
//  Meditation
//
//  Created by IOS-01 on 04/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MeditationMusicViewController : UIViewController
@property(nonatomic,strong)NSString * imageName;
@property(nonatomic,strong)NSString * musicName;
@property(nonatomic,strong)AVPlayer * songPlayer;
@property(nonatomic,strong)NSString * duration;
@property(nonatomic,strong)NSString * topicName;
@property(nonatomic,strong)NSString * topicId;
@property(nonatomic,strong)NSString * color;

@property (nonatomic, assign) BOOL guided;
@property (nonatomic, assign) BOOL global;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)backBtnAction:(id)sender;

@end
