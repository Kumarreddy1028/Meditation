//
//  MeditationNowCell.h
//  Meditation
//
//  Created by IOS-01 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeditationNowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *guidedbtn;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UIButton *guidedBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UIImage *imagedownloaded;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoTextViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startTrailling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBtnCenter;

@end
