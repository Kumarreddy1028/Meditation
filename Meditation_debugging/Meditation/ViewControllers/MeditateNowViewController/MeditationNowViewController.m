//
//  MeditationNowViewController.m
//  Meditation
//
//  Created by IOS-01 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "MeditationNowViewController.h"
#import "MeditationNowCell.h"
#import "MeditateNowModelClass.h"
#import "MeditationMusicViewController.h"
#import "SignInViewController.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"

@interface MeditationNowViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * arrayForBool;
    UIImageView *imageView;
    UIView *sectionView;
    UIButton *favourite;
    UILabel *rightLabel;
    NSMutableArray *addServices;
    NSTimer *audioTimer;
    BOOL flag, isStartBtnFrame, isServiceCalling;
    AVPlayerItem *playerItem;
    CGRect startBtnFrame;
}
@end

@implementation MeditationNowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[self navigationController] setNavigationBarHidden:YES];
    self.tableView.estimatedRowHeight = 180.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //----CALLING SERVER DATA METHOD----//
    
     [self serverData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addShadows:(CALayer *) layer {
    layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    layer.shadowOpacity = 40.0f;
    layer.shadowRadius = 20.0f;
}

#pragma mark-tableview data source method-


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeditationNowCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.previewBtn.hidden = YES;

    MeditateNowModelClass *obj=[_dataArray objectAtIndex:indexPath.section];

   CGSize size=[self getsizeOfString:obj.topicDescription andMaxWidth:self.view.frame.size.width-50 andFont:[UIFont systemFontOfSize:15]];
    
    if (size.height > 90)
    {
        size.height=90;
    }
    cell.cellImage.image = [UIImage new];
    if (obj.backgroudImage.length > 0) {
        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:obj.backgroudImage] placeholderImage:[UIImage imageNamed:@""]];
    }

    cell.infoTextViewHeight.constant=size.height;
   
    cell.infoTextView.text=obj.topicDescription;
    [cell.infoTextView setFont:[UIFont boldSystemFontOfSize:15.0]];
    [cell.infoTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [cell.infoTextView setTextColor:[UIColor colorWithRed:66.0/255 green:60.0/255 blue:79.0/255 alpha:1.0]];
    [cell.infoTextView setTextColor:[UIColor whiteColor]];
    

//    cell.infoTextView.layer.shadowColor = [[UIColor whiteColor] CGColor];
//    cell.infoTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    cell.infoTextView.layer.shadowOpacity = 1.0f;
//    cell.infoTextView.layer.shadowRadius = 5.0f;
    
    
//    [cell.infoTextView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
//    [cell.infoTextView.layer setBorderColor: [[UIColor grayColor] CGColor]];
//    [cell.infoTextView.layer setBorderWidth: 1.0];
//    [cell.infoTextView.layer setCornerRadius:12.0f];
//    [cell.infoTextView.layer setMasksToBounds:NO];
//    cell.infoTextView.layer.shouldRasterize = YES;
//    [cell.infoTextView.layer setShadowRadius:2.0f];
//    cell.infoTextView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    cell.infoTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    cell.infoTextView.layer.shadowOpacity = 1.0f;
//    cell.infoTextView.layer.shadowRadius = 1.0f;
    
    
    cell.infoTextView.backgroundColor = [UIColor clearColor];
    [self addShadows:cell.infoTextView.layer];
//    bottomLabel.numberOfLines = 1
//    cell.infoTextView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    cell.infoTextView.layer.shadowOpacity = 20.0f;
//    cell.infoTextView.layer.shadowRadius = 6.0f;
    
    
    
    NSString *drtn=obj.duration;
    NSArray *items = [drtn componentsSeparatedByString:@":"];
    NSString *drtnMin=[items objectAtIndex:1];
    NSString *drtnSec=[items objectAtIndex:2];
    NSString *finalDrtn=[NSString stringWithFormat:@"%dm %ds", [drtnMin intValue],[drtnSec intValue]];

    cell.labelDuration.text=finalDrtn;
    [cell.musicBtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
    [cell.guidedBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];

  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[obj.topicId stringByAppendingString:obj.duration] stringByAppendingString:@"_music.mp3"]];
    NSString *filePath1 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[obj.topicId stringByAppendingString:obj.duration]stringByAppendingString:@"_guided.mp3"]];
    
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[NSFileManager defaultManager] fileExistsAtPath:filePath1]))
    {
        cell.previewBtn.hidden = NO;
        cell.startBtnCenter.constant = (self.view.frame.size.width * 0.43)/2.0;
        
        if ([Utility sharedInstance].isDownloading && [obj.topicId isEqualToString:[Utility sharedInstance].downloadTopicId])
        {
            [cell.previewBtn setTitle:@"downloading..." forState:UIControlStateNormal];
        }
        else
        {
            [cell.previewBtn setTitle:@"download" forState:UIControlStateNormal];
        }
       
    }
    else
    {
        [cell.previewBtn setTitle:@"downloaded" forState:UIControlStateNormal];
        cell.previewBtn.hidden = YES;
        cell.startBtnCenter.constant = 0;
       // cell.startTrailling.constant = self.view.frame.size.width/2 - cell.startBtn.frame.size.width/2;
       // [cell.startBtn setNeedsUpdateConstraints];

    }

    cell.startBtn.titleLabel.textColor = [UIColor whiteColor];
    cell.previewBtn.titleLabel.textColor = [UIColor whiteColor];
    cell.guidedBtn.titleLabel.textColor = [UIColor whiteColor];
    cell.musicBtn.titleLabel.textColor = [UIColor whiteColor];

    
//    cell.startBtn.backgroundColor = [UIColor clearColor];
    [self addShadows:cell.startBtn.layer];


    [cell.startBtn setTag:indexPath.section];
    [cell.startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.startBtn.layer.cornerRadius=5.0;
    cell.startBtn.clipsToBounds=YES;
    cell.startBtn.layer.masksToBounds = NO;

    
    [cell.previewBtn setTag:indexPath.section];
    [cell.previewBtn addTarget:self action:@selector(previewBtnActn:) forControlEvents:UIControlEventTouchUpInside];
    cell.previewBtn.layer.cornerRadius=5.0;
    cell.previewBtn.clipsToBounds=YES;
    
    [cell.guidedBtn setTag:indexPath.section];
    [cell.guidedBtn addTarget:self action:@selector(guidedBtnActn:) forControlEvents:UIControlEventTouchUpInside];

    [cell.musicBtn setTag:indexPath.section];
    [cell.musicBtn addTarget:self action:@selector(musicBtnActn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addShadows:cell.labelDuration.layer];
    [self addShadows:cell.startBtn.layer];
    [self addShadows:cell.previewBtn.layer];
    [self addShadows:cell.guidedBtn.layer];
    [self addShadows:cell.musicBtn.layer];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

#pragma mark-tableView DelegateMethod-

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        
        return UITableViewAutomaticDimension;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    sectionView.tag=section;
    sectionView.backgroundColor=[UIColor whiteColor];
    MeditateNowModelClass *obj = [_dataArray objectAtIndex:section];
    //TO ADD A LABEL IN SECTION.
    
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10,_tableView.frame.size.width-60, 30)];
    
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor colorWithRed:66/255.0 green:60/255.0 blue:79/255.0 alpha:1];
    viewLabel.font=[UIFont systemFontOfSize:17];
    viewLabel.text=obj.topicName;
    [sectionView addSubview:viewLabel];
    
    favourite = [[UIButton alloc]init];
    [favourite setFrame:CGRectMake( _tableView.frame.size.width-43,1,35,35)];
   
    NSString *imageName;
    
    if ([obj.isLiked isEqualToString:@"0"] || obj.isLiked == nil) {
        imageName = @"favourite_unselect";
    }
    else
    {
        imageName = @"favourite_select";
    }
    
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [favourite setImage:btnImage forState:UIControlStateNormal];
     favourite.tag = section;
    
    [favourite addTarget:self action:@selector(favourite:) forControlEvents:UIControlEventTouchUpInside];
   
    [sectionView addSubview:favourite];

    //TO ADD A BUTTON IN SECTION.

    /***********Add a Label on sectionView **********/
    rightLabel=[[UILabel alloc]initWithFrame:CGRectMake( _tableView.frame.size.width-43,33,35,10)];
    rightLabel.font=[UIFont systemFontOfSize:11];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.text = [[Utility sharedInstance] convertNumberIntoDepiction:obj.likeCounts];
    rightLabel.textColor=[UIColor lightGrayColor];
    [sectionView addSubview:rightLabel];
    
    
    /********** Add a custom Separator with Section view *******************/
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, _tableView.frame.size.width, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:0.2];
    //separatorLineView.alpha = 0.2;
    [sectionView addSubview:separatorLineView];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    return  sectionView;
    
}

#pragma mark-Favourite ButtonAction-

-(void)favourite:(UIButton *)button
{
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn)
    {
        if (!isServiceCalling) {
            
        MeditateNowModelClass *obj = [_dataArray objectAtIndex:button.tag];
        isServiceCalling = YES;
        if ([obj.isLiked isEqualToString:@"0"])
        {
            [self changeRowLikeStateTo:rowLikeStateLike ofRowWithTopicId:obj andButton:button];
        }
        else
        {
            [self changeRowLikeStateTo:rowLikeStateUnlike ofRowWithTopicId:obj andButton:button];
        }
        }
    }
    else
    {
        //user is not logged in.
        
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Sign-in required" message:@"Please sign-in to like this audio." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"Sign-in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           SignInViewController *signInController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                           [self presentViewController:signInController animated:YES completion:nil];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:signInAction];
        [myAlert addAction:cancelAction];
        [self presentViewController:myAlert animated:YES completion:nil];
    }

}

-(void)changeRowLikeStateTo:(rowLikeState)LikeState ofRowWithTopicId:(MeditateNowModelClass *)topic andButton:(UIButton *)button
{
    NSString *serviceTopicLikeOrDislike;
    UIImage *imageToBeSet;
    switch (LikeState)
    {
        case rowLikeStateLike:
        {
            serviceTopicLikeOrDislike = @"SERVICE_USER_MEDITATION_TOPIC_LIKE";
            imageToBeSet = [UIImage imageNamed:@"favourite_select"];
        }
            break;
        case rowLikeStateUnlike:
        {
            serviceTopicLikeOrDislike = @"SERVICE_USER_MEDITATION_TOPIC_UNLIKE";
            imageToBeSet = [UIImage imageNamed:@"favourite_unselect"];
        }
            break;
            
        default:
            break;
    }
    
    if (![Utility isNetworkAvailable])
    {
//        [self.view makeToast:@"Network connection seems to be offline"];
        return;
    }
    NSString *userId = [Utility userId];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:serviceTopicLikeOrDislike forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:@"5345" forKey:@"device_token"];
    [dict setObject:topic.topicId forKey:@"topic_id"];
    [dict setObject:userId forKey:@"user_id"];
    
    //[SVProgressHUD showWithStatus:@"Liking Meditation Topic"];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          [SVProgressHUD dismiss];
          isServiceCalling = NO;

          if (!error)
          {
                NSLog(@"Reply JSON: %@", responseObject);
                if (responseObject[@"error_code"])//if response object contains a key named error_code.
                {
                    NSString *errorDesc=[responseObject objectForKey:@"error_desc"];
                    [self.view makeToast:errorDesc];
                }
                else
                {//there is no error in the response.
                  switch (LikeState)
                  {
                      case rowLikeStateLike:
                      {
                          topic.isLiked = @"1";
                          topic.likeCounts = [NSString stringWithFormat:@"%ld",[topic.likeCounts integerValue] + 1];
                      }
                          break;
                      case rowLikeStateUnlike:
                      {
                          topic.isLiked = @"0";
                          topic.likeCounts = [NSString stringWithFormat:@"%ld",[topic.likeCounts integerValue] - 1];
                      }
                          break;
                          
                      default:
                          break;
                  }
                    [button setImage:imageToBeSet forState:UIControlStateNormal];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationNone];

                   // [self serverData];
                }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];

}

#pragma mark-gestureRecognizerMethod-

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
     flag=NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
   
    if (indexPath.row == 0)
    {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[_dataArray count]; i++)
        {
            if (indexPath.section==i)
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                [_tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {   
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
                [_tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
   
    }
    
}

- (void)startBtnAction:(UIButton *)sender
{
    MeditationNowCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    MeditateNowModelClass *obj=[_dataArray objectAtIndex:sender.tag];
    

//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
    MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
    BOOL guided;
    if ([cell.musicBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_select"]])
    {
        cont.imageName=obj.musicImageName;
        guided = NO;
        if ([obj.musicFileName isEqualToString:@""])
        {
            cont.musicName=obj.musicMp3File;
        }
        else
        {
            cont.musicName=obj.musicFileName;
        }
        cont.color=obj.musicColorCode;
        cont.duration=obj.duration;
        cont.topicName=obj.topicName;
        cont.topicId=obj.topicId;
        cont.guided=guided;
        [self.navigationController pushViewController:cont animated:YES];
    }
    
    if ([cell.guidedBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_select"]])
    {
        cont.imageName=obj.guidedImageName;
        guided = YES;
        if ([obj.guidedFileName isEqualToString:@""])
        {
            cont.musicName=obj.guidedMp3File;
        }
        else
        {
            cont.musicName=obj.guidedFileName;
        }
        cont.color=obj.guidedColorCode;
        cont.duration=obj.duration;
        cont.topicName=obj.topicName;
        cont.topicId=obj.topicId;
        cont.guided=guided;


        [self.navigationController pushViewController:cont animated:YES];
    }
}

- (void)previewBtnActn:(UIButton*)sender
{
//    MeditationNowCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
//    
//    MeditateNowModelClass *obj=[_dataArray objectAtIndex:sender.tag];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//   
//    
//    if ([cell.musicBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_select"]])
//    {
//         NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[obj.topicId stringByAppendingString:@"_music.mp3"]];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//        {
//            self.songPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:obj.musicFileName]];
//            
//            [self.songPlayer play];
//            audioTimer=[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(audioStop) userInfo:nil repeats:YES];
//        }
//        else
//        {
//            AVAsset *eightBarAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
//            playerItem = [[AVPlayerItem alloc] initWithAsset:eightBarAsset];
//            self.songPlayer = [AVPlayer playerWithPlayerItem:playerItem];
//            
//            [self.songPlayer play];
//            audioTimer=[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(audioStop) userInfo:nil repeats:YES];
//            
//        }
//
//    }
//    
//    if ([cell.guidedBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_select"]])
//    {
//         NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[obj.topicId stringByAppendingString:@"_guided.mp3"]];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//        {
//            self.songPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:obj.guidedFileName]];
//            
//            [self.songPlayer play];
//            audioTimer=[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(audioStop) userInfo:nil repeats:YES];
//        }
//        else
//        {
//            AVAsset *eightBarAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
//            playerItem = [[AVPlayerItem alloc] initWithAsset:eightBarAsset];
//            self.songPlayer = [AVPlayer playerWithPlayerItem:playerItem];
//
//            [self.songPlayer play];
//            audioTimer=[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(audioStop) userInfo:nil repeats:YES];
//
//        }
//        
//    }
    MeditationNowCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    MeditateNowModelClass *obj=[_dataArray objectAtIndex:sender.
                                tag];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
//    if ([cell.musicBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_select"]])
//    {
//        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[obj.topicId stringByAppendingString:obj.duration]stringByAppendingString:@"_music.mp3"]];
//        NSString *filePath2 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[obj.topicId stringByAppendingString:@"_music.png"]];
        NSLog(@"filePath %@", filePath);
        
    NSString *filePath1 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[obj.topicId stringByAppendingString:obj.duration]stringByAppendingString:@"_guided.mp3"]];
    if (![Utility sharedInstance].isDownloading)
    {
    if (!([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[NSFileManager defaultManager] fileExistsAtPath:filePath1]))
        { // if file is not exist, create it.
            [Utility sharedInstance].isDownloading=YES;
            [Utility sharedInstance].downloadTopicId = obj.topicId;

            [cell.previewBtn setTitle:@"downloading..." forState:UIControlStateNormal];

//            MeditateNowModelClass *obj=[_dataArray objectAtIndex:sender.tag];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURL *URL;
            if ([obj.musicFileName isEqualToString:@""])
            {
                URL = [NSURL URLWithString:obj.musicMp3File];
            }
            else
            {
                URL = [NSURL URLWithString:obj.musicFileName];
            }
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                                      {
                                                          
                                                          NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                          return [documentsDirectoryURL URLByAppendingPathComponent:[[obj.topicId stringByAppendingString:obj.duration]stringByAppendingString:@"_music.mp3"]];
                                                      } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                                      {
                                                          if (!error)
                                                          {
                                                              NSURL *URL;
                                                              if ([obj.guidedFileName isEqualToString:@""])
                                                              {
                                                                  URL = [NSURL URLWithString:obj.guidedMp3File];
                                                              }
                                                              else
                                                              {
                                                                  URL = [NSURL URLWithString:obj.guidedFileName];
                                                              }
                                                              NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                                                              
                                                              NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                                                                                        {
                                                                                                            
                                                                                                            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                                                                            return [documentsDirectoryURL URLByAppendingPathComponent:[[obj.topicId stringByAppendingString:obj.duration]stringByAppendingString:@"_guided.mp3"]];
                                                                                                        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                                                                                        {
                                                                                                            if (!error)
                                                                                                            {
                                                                                                                [Utility sharedInstance].isDownloading = NO;
                                                                                                                [cell.previewBtn setTitle:@"downloaded" forState:UIControlStateNormal];
                                                                                                                cell.previewBtn.hidden =YES;
                                                                                                                        [self.view makeToast:@"file downloaded successfully"];
                                                                                                                [self.tableView reloadData];

                                                                                                                NSLog(@"File downloaded to: %@", filePath);
                                                                                                                [Utility sharedInstance].downloadTopicId =@"";
                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                [self.view makeToast:@"something went wrong"];
                                                                                                                [cell.previewBtn setTitle:@"download" forState:UIControlStateNormal];
                                                                                                                [Utility sharedInstance].isDownloading = NO;
                                                                                                                [Utility sharedInstance].downloadTopicId =@"";
                                                                                                            }
                                                                                                            
                                                                                                        }];
                                                              
                                                              
                                                              [downloadTask resume];

                                                              
                                                          }
                                                          else
                                                          {
                                                              [self.view makeToast:@"something went wrong"];
                                                              [cell.previewBtn setTitle:@"download" forState:UIControlStateNormal];
                                                              [Utility sharedInstance].isDownloading = NO;
                                                              [Utility sharedInstance].downloadTopicId =@"";
                                                          }
                                                          
                                                      }];
            
            
            [downloadTask resume];
        }
        else
        {
            [self.view makeToast:@"This File already exist"];
        }
    }
    else
    {
          [self.view makeToast:@"please wait your last download is not completed yet"];
    }
}

-(void)audioStop
{
    [self.songPlayer pause];
    [audioTimer invalidate];
}

- (void)menuBtnActn:(id)sender
{
    [self.songPlayer pause];

    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];

}

- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}

- (IBAction)infoBtnActn:(id)sender
{
    self.closeBtn.hidden=NO;
    self.infoWebView.hidden=NO;
    self.menuBtn.hidden=YES;
    self.infoBtn.hidden=YES;
    self.dashboardBtn.hidden = YES;
    self.titleMeditateNow.hidden = YES;
    [self serviceCallForInfo];
}

- (IBAction)closleBtnActn:(id)sender
{
    self.menuBtn.hidden=NO;
    self.infoBtn.hidden=NO;
    self.dashboardBtn.hidden =NO;
    self.titleMeditateNow.hidden = NO;

    self.closeBtn.hidden=YES;
    self.infoWebView.hidden=YES;
}
//
//- (IBAction)infoBtnActn:(UIButton *)sender
//{
//   
//}
//    //    NSString *str=@"jbfgbijgbdfggb uyg hjk fhj jug h gi dfsg dfjsgdfhjgyf gfgdfkghjdfklhgjdf  hgjdfhjkghjkbfk fdhbfdhjksf dhsbfh";
    //    if ([Utility sharedInstance].isDeviceIpad)
    //    {
    //        [self.infoTextview setTextContainerInset:UIEdgeInsetsMake(50, 60, 50, 60)];
    //        [self.infoTextview setFont:[UIFont systemFontOfSize:20]];    }
    //    else
    //    {
    //        [self.infoTextview setTextContainerInset:UIEdgeInsetsMake(25, 30, 25, 30)];
    //
    //
    //
    //        self.infoTextview.attributedText = [Utility changeLineSpacing:str];
    //    }
    
    //    self.infoTextview.textAlignment = NSTextAlignmentLeft;
    

//
//- (IBAction)closeButtonActn:(UIButton *)sender {
//
//    
//    
//    
//}
//
-(void)serviceCallForInfo
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"MEDITATION_INFORMATION" forKey:@"REQUEST_TYPE_SENT"];
    
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if ([responseObject isKindOfClass:[NSDictionary class]])
          {
              responseObject = [Utility convertDictionaryIntoUTF8:[responseObject allValues] dictionary:responseObject];
          }
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                  
              }
              else
              {
                  if ([responseObject objectForKey:@"error_code"])
                  {
                      
                  }
                  else if ([responseObject isKindOfClass:[NSDictionary class]])
                  {
                      NSURL *url = [NSURL URLWithString:[responseObject objectForKey:@"info_url"]];
                      [self.infoWebView loadRequest:[NSURLRequest requestWithURL:url]];
                      self.infoWebView.scrollView.bounces = NO;
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}


//- (void)infoBtnActn:(UIButton*)sender
//{
//    MeditationNowCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
//    
//    if (flag)
//    {
//        cell.infoLabel.numberOfLines=2;
//        [cell.infoButton setImage:[UIImage imageNamed:@"info_icon"] forState:UIControlStateNormal];
//        flag=NO;
//    }
//    else
//    {
//        cell.infoLabel.numberOfLines=0;
//        [cell.infoButton setImage:[UIImage imageNamed:@"info_icon_cancel"] forState:UIControlStateNormal];
//
//         flag=YES;
//
//    }
//    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:-1 inSection:sender.tag]]withRowAnimation:UITableViewRowAnimationAutomatic];
////    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//
//}

//-(void)downloadBtnActn:(UIButton *)sender
//{
//  
//}
- (void)musicBtnActn:(UIButton *)sender
{
    MeditationNowCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    if ([cell.musicBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_unselect"]])
    {
      
        [cell.musicBtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
        [cell.guidedBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.musicBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
        [cell.guidedBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
     }
}

- (void)guidedBtnActn:(UIButton *)sender
{
    MeditationNowCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];

    if ([cell.guidedBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_unselect"]])
    {
        [cell.guidedBtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
        [cell.musicBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.guidedBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
        [cell.musicBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
    }
}

#pragma mark-METHOD FOR SEVER DATA-

-(void)serverData
{
    // NSString *uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"u_id"];  //Storing userID
    if (![Utility isNetworkAvailable]) {
        return;
    }
     NSString *userId = [Utility userId];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:@"SERVICE_USER_MEDITATION_TOPIC" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:userId forKey:@"user_id"];
    
    [SVProgressHUD show];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {

          responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];

          [SVProgressHUD dismiss];
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              
              if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                  NSArray *servicesArr=[[NSArray alloc]init];
                  
                  servicesArr=[responseObject objectForKey:@"meditation_topics"];
                  if (servicesArr.count)
                  {
                  _dataArray=[NSMutableArray new];
                  for(NSDictionary *dic in servicesArr)
                  {
                      MeditateNowModelClass *obj=[[MeditateNowModelClass alloc]initWithDictionary:dic];
                      [_dataArray addObject:obj];
                      
                      arrayForBool=[[NSMutableArray alloc]init];
                      
                      for (int i=0; i<[_dataArray count]; i++)
                      {
                          [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                      }
                      
                  }
                  [_tableView reloadData];
                 }
              }
          }
              else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

-(CGSize)getsizeOfString:(NSString *)string andMaxWidth:(CGFloat)widthValue andFont:(UIFont *)font{
    CGSize size;
    CGRect frame = [string boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    size = CGSizeMake(frame.size.width, frame.size.height);
    return size;
}

@end
