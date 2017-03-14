//
//  CustomProgressViewController.h
//  Meditation
//
//  Created by IOS-01 on 22/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomProgressViewController : UIProgressView

@property(strong,nonatomic)UIImage *trackImg;
@property(strong,nonatomic)UIImage *progressImg;
@property(strong,nonatomic)UIImageView *imgViewTrack;
@property(strong,nonatomic)UIImageView *imgViewprogress;
@property(strong,nonatomic)UIView *progressView;

-(UIView *)DrawProgressView;

@end
