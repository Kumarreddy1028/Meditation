//
//  CustomProgressViewController.m
//  Meditation
//
//  Created by IOS-01 on 22/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "CustomProgressViewController.h"

@implementation CustomProgressViewController

- (UIView *)DrawProgressView
{
    _progressImg=[[UIImage alloc] init];
    _progressImg=[UIImage imageNamed:@"duration"];
    
    _trackImg=[[UIImage alloc]init];
    _trackImg=[UIImage imageNamed:@"duration_unfill"];
    
    _progressView=[[UIView alloc]initWithFrame:CGRectMake(50,440, 210, 15)];
//    _progressView.backgroundColor=[UIColor b+lackColor];
    
    _imgViewTrack=[[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, 210, 15)];
    _imgViewprogress=[[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 0, 15)];
    _imgViewprogress.backgroundColor=[UIColor redColor];
    
    _imgViewTrack.image=_trackImg;
    _imgViewprogress.image=_progressImg;
    _imgViewTrack.userInteractionEnabled=YES;
    _imgViewprogress.userInteractionEnabled=YES;
    
    [_progressView addSubview:_imgViewTrack];
    [_progressView addSubview:_imgViewprogress];
    
    _progressView.userInteractionEnabled=YES;
    return _progressView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
