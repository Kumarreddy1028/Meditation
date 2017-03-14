//
//  MeditationNowViewController.m
//  Meditation
//
//  Created by IOS-01 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "MeditateNowIpadViewController.h"
#import "MeditateNowIpadCell.h"
#import "MeditateNowModelClass.h"
#import "MeditationMusicViewController.h"
#import "SignInViewController.h"
#import "UIImageView+WebCache.h"

@interface MeditateNowIpadViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer *audioTimer;
    MeditateNowModelClass *selectedObj, *downloadingObject;
    NSInteger no;
    NSIndexPath *selectedIndexPath;
    bool isServiceCalling;
}
@end

@implementation MeditateNowIpadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES];
    [self.detailView setHidden:YES];
    self.previewBtn.layer.cornerRadius=10.0;
    self.previewBtn.clipsToBounds=YES;
    self.startBtn.layer.cornerRadius=10.0;
    self.startBtn.clipsToBounds=YES;
    selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //----CALLING SERVER DATA METHOD----//
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self serverData];
}

#pragma mark-METHOD FOR SEVER DATA-

-(void)serverData
{
    if (![Utility isNetworkAvailable]) {
        return;
    }
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:@"SERVICE_USER_MEDITATION_TOPIC" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:[Utility userId] forKey:@"user_id"];
    
    [SVProgressHUD show];
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
                  _dataArray=[[NSMutableArray alloc] init];
                  for(NSDictionary *dic in servicesArr)
                  {
                      MeditateNowModelClass *obj=[[MeditateNowModelClass alloc]initWithDictionary:dic];
                      [_dataArray addObject:obj];
                      
                  }
                  [_tableView reloadData];
                  NSIndexPath *firstRowPath = [NSIndexPath indexPathForRow:0 inSection:0];
                  [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
                  [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
                    }
              }
          } else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark-tableview data source method-

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeditateNowIpadCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    MeditateNowModelClass *obj=[_dataArray objectAtIndex:indexPath.row];
    [cell.selectedView setBackgroundColor:[UIColor clearColor]];
    
    NSString *imageName;
    
    if ([obj.isLiked isEqualToString:@"0"] || obj.isLiked == nil) {
        imageName = @"favourite_unselect";
    }
    else
    {
        imageName = @"favourite_select";
    }
    cell.lblMeditationTopic.text=obj.topicName;
    cell.lblUserLikes.text = [[Utility sharedInstance] convertNumberIntoDepiction:obj.likeCounts];

    [cell.favouriteBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    cell.favouriteBtn.tag = indexPath.row;
    
    [cell.favouriteBtn addTarget:self action:@selector(favourite:) forControlEvents:UIControlEventTouchUpInside];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    [self.musicBtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
    [self.guidedbtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
    [self.detailView setHidden:NO];
    selectedObj=[_dataArray objectAtIndex:indexPath.row];
    if (![Utility sharedInstance].isDownloading)
        downloadingObject=[_dataArray objectAtIndex:indexPath.row];
    NSString *drtn=selectedObj.duration;
    NSArray *items = [drtn componentsSeparatedByString:@":"];
    //   NSString *drtnHour=[items objectAtIndex:0];
    NSString *drtnMin=[items objectAtIndex:1];
    NSString *drtnSec=[items objectAtIndex:2];
    NSString *finalDrtn=[NSString stringWithFormat:@"%dm %ds", [drtnMin intValue],[drtnSec intValue]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[selectedObj.topicId stringByAppendingString:selectedObj.duration] stringByAppendingString:@"_music.mp3"]];
    NSString *filePath1 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[selectedObj.topicId stringByAppendingString:selectedObj.duration]stringByAppendingString:@"_guided.mp3"]];
    if (!([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[NSFileManager defaultManager] fileExistsAtPath:filePath1]))
    {
        self.previewBtn.hidden = NO;
        self.startBtnTrailling.constant = 41;
        if ([Utility sharedInstance].isDownloading && [selectedObj.topicId isEqualToString:[Utility sharedInstance].downloadTopicId])
        {

            [self.previewBtn setTitle:@"downloading..." forState:UIControlStateNormal];
        }
        else
        {
            [self.previewBtn setTitle:@"download" forState:UIControlStateNormal];
        }
        
    }
    else
    {
        self.previewBtn.hidden = YES;
        self.startBtnTrailling.constant = self.detailView.frame.size.width/2 - self.startBtn.frame.size.width/2;
//        [self.previewBtn setTitle:@"downloaded" forState:UIControlStateNormal];
    }

    self.labelDuration.text = finalDrtn;
    self.infoLabel.text=selectedObj.topicDescription;
    self.backgroundImage.image =[UIImage new];
    if (selectedObj.backgroudImage.length > 0) {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:selectedObj.backgroudImage] placeholderImage:[UIImage imageNamed:@""]];
    }

   // self.backgroundImage.alpha = 0.5;
//    self.lblMedtationTopic.text = selectedObj.topicName;
    
    [self addShadows:self.labelDuration.layer];
    [self addShadows:self.infoLabel.layer];
    [self addShadows:self.startBtn.layer];
    [self addShadows:self.previewBtn.layer];
    [self addShadows:self.guidedbtn.layer];
    [self addShadows:self.musicBtn.layer];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeditateNowIpadCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedView setBackgroundColor:[UIColor clearColor]];
}

- (void) addShadows:(CALayer *) layer {
    layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    layer.shadowOpacity = 40.0f;
    layer.shadowRadius = 20.0f;
}


#pragma mark-Favourite ButtonAction-

-(void)favourite:(UIButton *)button
{
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn)
    {
        if (!isServiceCalling) {
            isServiceCalling = YES;
        MeditateNowModelClass *obj = [_dataArray objectAtIndex:button.tag];
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

-(void)changeRowLikeStateTo:(rowLikeState)LikeState ofRowWithTopicId:(MeditateNowModelClass *)model andButton:(UIButton *)button
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
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:model.topicId forKey:@"topic_id"];
    [dict setObject:userId forKey:@"user_id"];
    
    //[SVProgressHUD showWithStatus:@"Liking Meditation Topic"];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          isServiceCalling = NO;
          [SVProgressHUD dismiss];
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
                  [button setImage:imageToBeSet forState:UIControlStateNormal];
//                  switch (LikeState)
//                  {
//                      case rowLikeStateLike:
//                      {
//                          model.isLiked = @"1";
//                          model.likeCounts = [NSString stringWithFormat:@"%ld",[model.likeCounts integerValue] + 1];
//                      }
//                          break;
//                      case rowLikeStateUnlike:
//                      {
//                          model.isLiked = @"0";
//                          model.likeCounts = [NSString stringWithFormat:@"%ld",[model.likeCounts integerValue] - 1];
//                      }
//                          break;
//                          
//                      default:
//                          break;
//                  }
//
//                 
                  
                  [self serverData];
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
    
}

- (IBAction)startBtnAction:(UIButton *)sender
{
    if ([self.musicBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_select"]])
    {
        
        
        MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
        
        cont.imageName=selectedObj.musicImageName;
        cont.duration=selectedObj.duration;
        cont.topicName=selectedObj.topicName;
        cont.color=selectedObj.musicColorCode;
        cont.topicId = selectedObj.topicId;
        cont.guided=NO;
        if ([selectedObj.musicFileName isEqualToString:@""])
        {
            cont.musicName=selectedObj.musicMp3File;
        }
        else
        {
            cont.musicName=selectedObj.musicFileName;
        }
        [self.navigationController pushViewController:cont animated:YES];

    }
    else if ([self.guidedbtn.imageView.image isEqual:[UIImage imageNamed:@"pin_select"]])
    {
        MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];

        cont.imageName=selectedObj.guidedImageName;
        cont.duration=selectedObj.duration;
        cont.topicName=selectedObj.topicName;
        cont.color=selectedObj.guidedColorCode;
        cont.topicId = selectedObj.topicId;
        cont.guided=YES;

        if ([selectedObj.guidedFileName isEqualToString:@""])
        {
            cont.musicName=selectedObj.guidedMp3File;
        }
        else
        {
            cont.musicName=selectedObj.guidedFileName;
        }
        [self.navigationController pushViewController:cont animated:YES];
    }
    
}

- (IBAction)previewBtnActn:(UIButton*)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[downloadingObject.topicId stringByAppendingString:downloadingObject.duration]stringByAppendingString:@"_music.mp3"]];
    NSLog(@"filePath %@", filePath);
    
    NSString *filePath1 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[[downloadingObject.topicId stringByAppendingString:downloadingObject.duration]stringByAppendingString:@"_guided.mp3"]];
    if (![Utility sharedInstance].isDownloading)
    {
        if (!([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[NSFileManager defaultManager] fileExistsAtPath:filePath1]))
        { // if file is not exist, create it.
            [Utility sharedInstance].isDownloading=YES;
            [Utility sharedInstance].downloadTopicId = downloadingObject.topicId;
            
            [self.previewBtn setTitle:@"downloading..." forState:UIControlStateNormal];
            
            //            MeditateNowModelClass *obj=[_dataArray objectAtIndex:sender.tag];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURL *URL;
            if ([selectedObj.musicFileName isEqualToString:@""])
            {
                URL = [NSURL URLWithString:downloadingObject.musicMp3File];
            }
            else
            {
                URL = [NSURL URLWithString:downloadingObject.musicFileName];
            }
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                                      {
                                                          
                                                          NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                          return [documentsDirectoryURL URLByAppendingPathComponent:[[downloadingObject.topicId stringByAppendingString:downloadingObject.duration]stringByAppendingString:@"_music.mp3"]];
                                                      } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                                      {
                                                          if (!error)
                                                          {
                                                              
                                                              NSURL *URL;
                                                              if ([downloadingObject.guidedFileName isEqualToString:@""])
                                                              {
                                                                  URL = [NSURL URLWithString:downloadingObject.guidedMp3File];
                                                              }
                                                              else
                                                              {
                                                                  URL = [NSURL URLWithString:downloadingObject.guidedFileName];
                                                              }
                                                              NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                                                              
                                                              NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                                                                                        {
                                                                                                            
                                                                                                            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                                                                            return [documentsDirectoryURL URLByAppendingPathComponent:[[downloadingObject.topicId stringByAppendingString:downloadingObject.duration]stringByAppendingString:@"_guided.mp3"]];
                                                                                                        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                                                                                        {
                                                                                                            if (!error)
                                                                                                            {
                                                                                                                [Utility sharedInstance].isDownloading = NO;
                                                                                                                [self.previewBtn setTitle:@"downloaded" forState:UIControlStateNormal];
                                                     self.startBtnTrailling.constant = self.detailView.frame.size.width/2 - self.startBtn.frame.size.width/2;                                               self.previewBtn.hidden = YES;                                                    [self.view makeToast:@"file downloaded successfully"];
                                                                                                    NSLog(@"File downloaded to: %@", filePath);
                                                                                                                [Utility sharedInstance].downloadTopicId =@"";
                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                [self.view makeToast:@"something went wrong"];
                                                                                                                [self.previewBtn setTitle:@"download" forState:UIControlStateNormal];
                                                                                                                
                                                      [Utility sharedInstance].isDownloading = NO;
                                                                                                                [Utility sharedInstance].downloadTopicId =@"";
                                                                                                            }                                                                                                        }];
                                                              
                                                              
                                                              [downloadTask resume];
                                                              
                                                              
                                                          }
                                                          else
                                                          {
                                                              [self.view makeToast:@"something went wrong"];
                                                              [self.previewBtn setTitle:@"download" forState:UIControlStateNormal];
                      
                                                              
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

- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}

- (IBAction)closeBtnActn:(id)sender
{
    
    self.menuBtn.hidden=NO;
    self.infoBtn.hidden=NO;
    self.dashboardBtn.hidden =NO;
    self.titleMeditateNow.hidden = NO;
    
    self.closeBtn.hidden=YES;
    self.infoWebView.hidden=YES;
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

- (void)menuBtnActn:(id)sender
{
    [self.songPlayer pause];
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)musicBtnActn:(UIButton *)sender
{
    
    if ([self.musicBtn.imageView.image isEqual:[UIImage imageNamed:@"pin_unselect"]])
    {
        [self.musicBtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
        [self.guidedbtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
    }
    else
    {
        [self.musicBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
        [self.guidedbtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
    }
}

- (IBAction)guidedBtnActn:(UIButton *)sender
{
 
    if ([self.guidedbtn.imageView.image isEqual:[UIImage imageNamed:@"pin_unselect"]])
    {
        [self.guidedbtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
        [self.musicBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.guidedbtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
        [self.musicBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
    }
}
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
      { if ([responseObject isKindOfClass:[NSDictionary class]])
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


@end
