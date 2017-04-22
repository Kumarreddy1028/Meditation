//
//  MeditationMusicViewController.m
//  Meditation
//
//  Created by IOS-01 on 04/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "MeditationMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomProgressViewController.h"
#import "MeditateNowModelClass.h"
#import "UIImageView+WebCache.h"
@interface MeditationMusicViewController ()
{
    CMTime currentPlayTime;
    BOOL paused,stop,network;
    NSTimer *audioTimer;
    int currSeconds, currMinute,currHour,totalDurationInSeconds;
    CustomProgressViewController *objProgress;
    UIButton *playButton;
    UILabel *labelFirst;
    UILabel *labelSecond;
    UIView *customProgressView;
    float progressWidth;
    AVPlayerItem *playerItem;
    double prevDuration;
    NSString *filePath;
    bool fPath;
    BOOL playing;
    NSString *currentTimeString;
}
@end

@implementation MeditationMusicViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.imageName.length > 0) {
        [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:self.imageName] placeholderImage:[UIImage imageNamed:@""]];
    }
//    else
//    {
//        [self.backGroundImage setImage:[UIImage imageNamed:@"girl_big"]];
//    }
    currMinute = 0;
    currSeconds = 0;
    currHour = 0;
    self.titleLabel.text=self.topicName;
  
    totalDurationInSeconds = [self setTotalDuration];
    progressWidth=0;
    objProgress=[[CustomProgressViewController alloc]init];
    UIImage *btnImage = [UIImage imageNamed:@"play"];
    
    playButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-48, self.view.frame.size.height - 190, 96, 97)];
    
    [playButton setImage:btnImage forState:UIControlStateNormal];
    [playButton setImage:btnImage forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    float width, frameX;
    if ([Utility sharedInstance].isDeviceIpad)
    {
        width = 400;
        frameX = (self.view.frame.size.width - 400)/2;
    }
    else
    {
        width = self.view.frame.size.width-100;
        frameX = (self.view.frame.size.width - width)/2;
    }
    labelFirst =[[UILabel alloc]initWithFrame:CGRectMake(frameX, self.view.frame.size.height - 85, 80, 20)];
    [labelFirst setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:18]];
    labelSecond =[[UILabel alloc]initWithFrame:CGRectMake(frameX + width - 90, self.view.frame.size.height - 85, 90, 20)];
    NSString *slt=self.duration;
    [labelSecond setFont:[UIFont fontWithName:@"ProximaNova-Bold" size:18]];

    labelFirst.textColor =  [self colorWithHexString:self.color];
    labelSecond.textColor =  [self colorWithHexString:self.color];
    self.titleLabel.textColor = [self colorWithHexString:self.color];

    labelFirst.text = @"loading..";
    labelFirst.textAlignment = NSTextAlignmentLeft;
    labelSecond.text = [self changeTimeformat:slt];
    labelSecond.textAlignment = NSTextAlignmentRight;
    customProgressView=objProgress.DrawProgressView;
    [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];

    
    [customProgressView setFrame:CGRectMake(frameX, self.view.frame.size.height - 60, width, 15)];
    
    progressWidth=objProgress.imgViewprogress.frame.size.width;
    
    [objProgress.imgViewTrack setFrame:CGRectMake(0, 0,customProgressView.frame.size.width, 15)];
    if (!self.global)
    {
        [self.view addSubview:playButton];
    }
    [self.view addSubview:labelFirst];
    [self.view addSubview:labelSecond];
    [self.view addSubview:customProgressView];
    
   // [self playBtnAction:playButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
  
    if (self.guided)
    {
        filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[self.topicId stringByAppendingString:self.duration]stringByAppendingString:@"_guided.mp3"]];
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[self.topicId stringByAppendingString:self.duration]stringByAppendingString:@"_music.mp3"]];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        fPath = YES;
        //self.songPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:self.musicName]];
        playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.musicName]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_songPlayer currentItem]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerStalled:)
                                                     name:AVPlayerItemPlaybackStalledNotification
                                                   object:[_songPlayer currentItem]];
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        self.songPlayer = [AVPlayer playerWithPlayerItem:playerItem];
        
        [self.songPlayer play];
    }
    else
    {
        AVAsset *eightBarAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
        playerItem = [[AVPlayerItem alloc] initWithAsset:eightBarAsset];
        self.songPlayer = [AVPlayer playerWithPlayerItem:playerItem];
        
        [self.songPlayer play];
    }
    [UIApplication sharedApplication].idleTimerDisabled = YES;
//    audioTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(audioProgressUpdate) userInfo:nil repeats:YES];
    playButton.selected = !playButton.selected;
    
}

- (int)setTotalDuration
{
    NSArray *timeArray = [self.duration componentsSeparatedByString:@":"];
    NSString *hourString = [timeArray objectAtIndex:0];
    NSString *minuteString = [timeArray objectAtIndex:1];
    NSString *secondString = [timeArray objectAtIndex:2];
    int hourDuration = [hourString intValue];
    int minuteDuration = [minuteString intValue];
    int secondDuration = [secondString intValue];
    return (secondDuration + minuteDuration*60 + hourDuration*60*60);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [audioTimer invalidate];
    audioTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
- (void)playBtnAction:(UIButton*)sender
{

    if ([labelFirst.text isEqualToString:@"loading.."]) {
        return;
    }

    
    if ([playButton isSelected])
    {
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];
//         NSString *currentTimeString = [NSString stringWithFormat:@"%02d:%02d:%02d",currHour,currMinute,currSeconds];
        //labelFirst.text=[self changeTimeformat:currentTimeString];

        [audioTimer invalidate];
        audioTimer = nil;
        [playButton setSelected:NO];
        [self.songPlayer pause];
        currentPlayTime = self.songPlayer.currentTime;
        paused =YES;
    }
    else
    {
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected | UIControlStateHighlighted];
        if (stop)
        {
            [self.songPlayer seekToTime:kCMTimeZero];
            stop = NO;
        }
        if (paused)
        {
            paused = NO;
            [self.songPlayer seekToTime:currentPlayTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        }
        else
        {
            currSeconds = 0;
            totalDurationInSeconds = [self setTotalDuration];
        }
//        [self.songPlayer setAutomaticallyWaitsToMinimizeStalling:YES];
        [self.songPlayer play];
        [playButton setSelected:YES];
        audioTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(audioProgressUpdate) userInfo:nil repeats:YES];
    }
}

- (void)playerStalled:(NSNotification *)notification {
    NSLog(@"playerStalled");
}


- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if (![Utility isNetworkAvailable])
    {
        currentPlayTime = self.songPlayer.currentTime;
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];
        [audioTimer invalidate];
        audioTimer = nil;
        [playButton setSelected:NO];
        [playButton setEnabled:NO];
        network = YES;

    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (!self.songPlayer)
    {
        return;
    }
    else if ([currentTimeString isEqualToString:self.duration])
    {
        return;
    }
    else if (object == playerItem && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (playerItem.playbackBufferEmpty)
        {
            if (![Utility isNetworkAvailable])
            {
                currentPlayTime = self.songPlayer.currentTime;
                [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];
                [audioTimer invalidate];
                [playButton setSelected:NO];
                [playButton setEnabled:NO];
                network = YES;
            }

        }
    }
    
    else if (object == playerItem && [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (playerItem.playbackLikelyToKeepUp)
        {
            [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected | UIControlStateHighlighted];
            [playButton setSelected:YES];
            [playButton setEnabled:YES];
            [self.songPlayer play];
            if (!audioTimer)
            {
                labelFirst.text = @"started..";
                audioTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(audioProgressUpdate) userInfo:nil repeats:YES];
                network = NO;
            }
            
            //Your code here
        }
    }
    else if (object == self.songPlayer && [keyPath isEqualToString:@"status"])
    {
        if (self.songPlayer.status == AVPlayerStatusFailed)
        {
            NSLog(@"AVPlayer Failed");
        }
    }
}
-(void)audioProgressUpdate  // ..AUDIO TIMER FUCNTION..
{
    AVPlayerItem *thePlayerItem = [self.songPlayer currentItem];
    float widtPer = ((CMTimeGetSeconds(thePlayerItem.currentTime)*100)/CMTimeGetSeconds(thePlayerItem.duration));

    if (isnan(widtPer)) {
        return;
    }
//    double dur = CMTimeGetSeconds(thePlayerItem.duration);
   // progressWidth = (widtPer*customProgressView.frame.size.width)/100.0;

    if (progressWidth <= customProgressView.frame.size.width) {
        [objProgress.imgViewprogress setFrame:CGRectMake(0, 0,progressWidth, 15)];
    }
    
    progressWidth += (customProgressView.frame.size.width)/[self setTotalDuration];

    currentTimeString = [NSString stringWithFormat:@"%02d:%02d:%02d",currHour,currMinute,currSeconds];

   // labelFirst.text=[NSString stringWithFormat:@"%.0fm %.0fs", (CMTimeGetSeconds(thePlayerItem.currentTime)/60),fmod(CMTimeGetSeconds(thePlayerItem.currentTime),60)];

    labelFirst.text=[self changeTimeformat:currentTimeString];
    labelSecond.text=[NSString stringWithFormat:@"-%dm %ds", (totalDurationInSeconds/60),(totalDurationInSeconds%60)];

    if ([currentTimeString isEqualToString:self.duration])
    {
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateHighlighted];
//        [self.songPlayer seekToTime:kCMTimeZero];
        [objProgress.imgViewprogress setFrame:CGRectMake(0, 0,customProgressView.frame.size.width, 15)];

        [audioTimer invalidate];
        
        [playButton setSelected:NO];
        currHour = 0;
        currMinute = 0;
        currSeconds = 0;
        progressWidth = 0;
        NSString *currentTimeString = [NSString stringWithFormat:@"%02d:%02d:%02d",currHour,currMinute,currSeconds];
      //  labelFirst.text=[self changeTimeformat:currentTimeString];
        stop = YES;
        
      //  labelFirst.text=[NSString stringWithFormat:@"%.0fm %.0fs", (CMTimeGetSeconds(thePlayerItem.currentTime)/60),fmod(CMTimeGetSeconds(thePlayerItem.currentTime),60)];
        labelSecond.text=[NSString stringWithFormat:@"-%dm %ds", (totalDurationInSeconds/60),(totalDurationInSeconds%60)];
        [self.songPlayer pause];

    }
    else
    {
        totalDurationInSeconds--;
//        currSeconds++;
        if (currSeconds < 59)
        {
            currSeconds++;
        }
        else if (currMinute < 60)
        {
           currMinute++;
            currSeconds=0;
        }
        else
        {
            currHour++;
            currMinute=0;
            currSeconds=0;
        }
    }
    
}
-(NSString *)changeTimeformat:(NSString*)str
{
        NSArray *items = [str componentsSeparatedByString:@":"];
        //   NSString *drtnHour=[items objectAtIndex:0];
        NSString *drtnMin=[items objectAtIndex:1];
        NSString *drtnSec=[items objectAtIndex:2];
        NSString *finalDrtn=[NSString stringWithFormat:@"%dm %ds", [drtnMin intValue],[drtnSec intValue]];
    
    return finalDrtn;
}
- (IBAction)backBtnAction:(id)sender
{
    if (fPath)
    {
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
    [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    [playerItem removeObserver:self forKeyPath:@"status" context:nil];

    }
    [self.songPlayer pause];
    [self.navigationController popViewControllerAnimated:YES];
    [UIApplication sharedApplication].idleTimerDisabled = NO;

}

@end
