//
//  VideoListViewController.m
//  Meditation
//
//  Created by IOS1-2016 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoInfoModel.h"
#import "VideoListTableViewCell.h"
#import "SignInViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface VideoListViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, YTPlayerViewDelegate>
{
    NSMutableArray *arrVideoInfoModelObjects;
    BOOL isFullScreen, isCallingService;
    BOOL rowShouldExpand;
    NSIndexPath *indexPathToExpand;
    VideoListTableViewCell *prevCell;
//    long indexPathToExpand;
//    CGFloat expandedRowHeight;
    CGFloat normalRowHeight;
   // VideoListTableViewCell *selectedCell;
    NSInteger selectedRow;
    YTPlayerView *playerView;
}
@end

@implementation VideoListViewController

#pragma  mark-View lifecycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
    normalRowHeight = 105;
    playerView.delegate = self;
    [self initializeVideoInfoModel];
//    self.playerViewMaxHeight = self.view.frame.size.height/playerView_Height_devider + playerView_Height_adder;
//    self.playerViewMinHeight = 100;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    self.blurView.hidden = YES;
//    self.playerViewState = playerViewStateClosed;
//}
-(void)initializeVideoInfoModel
{
    //----WEB SERVICES---------//
    [SVProgressHUD show];
    self.blurView.hidden = NO;
    NSString *userId = [Utility userId];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_VIDEOS" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:userId forKey:@"user_id"];
    
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if ([responseObject isKindOfClass:[NSDictionary class]]) {
              responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
          }
          
          [SVProgressHUD dismiss];
          self.blurView.hidden = YES;
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              if (responseObject[@"error_code"])//if response object contains a key named error_code.
              {
                  NSString *error_code=[responseObject objectForKey:@"error_code"];
                  NSString *error_desc=[responseObject objectForKey:@"error_desc"];
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:error_code message:error_desc preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
              }
              else
              {
                  NSArray *arrVideList = [responseObject objectForKey:@"video_list"];
                  NSDictionary *dictVideoInfo = [[NSDictionary alloc]init];
                  arrVideoInfoModelObjects = [NSMutableArray new];
                  for (dictVideoInfo in arrVideList )
                  {
                      VideoInfoModel *obj = [[VideoInfoModel alloc]initWithDictionary:dictVideoInfo];
                      [arrVideoInfoModelObjects addObject:obj];
                  }
                  [self.tableView reloadData];
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
              UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong. Please retry." preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
              [myAlert addAction:action];
              [self presentViewController:myAlert animated:YES completion:nil];
          }
      }] resume];
}

- (IBAction)backActionButton:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    [SVProgressHUD dismiss];
}

#pragma mark - TableViewDatasource methods.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrVideoInfoModelObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    VideoInfoModel *obj = [arrVideoInfoModelObjects objectAtIndex:indexPath.row];
    cell.playerView.delegate = self;
    if ([[Utility sharedInstance]isDeviceIpad])
    {
        CGSize size=[self getsizeOfString:obj.videoTitle andMaxWidth:self.view.frame.size.width-150 andFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.0f]];
        if (size.height >= 25)
        {
            cell.lblVideoDescription.numberOfLines = 2;
        }
        else
        {
            cell.lblVideoDescription.numberOfLines = 3;
            
        }
    }
    else
    {
        CGSize size=[self getsizeOfString:obj.videoTitle andMaxWidth:self.view.frame.size.width-150 andFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15.0f]];
        if (size.height >= 20)
        {
            cell.lblVideoDescription.numberOfLines = 2;
        }
        else
        {
            cell.lblVideoDescription.numberOfLines = 3;
            
        }
    }
  
    
    [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:obj.videoImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.lblVideoTitle.text = obj.videoTitle;
    cell.lblVideoDescription.text = obj.videoDescription;
    cell.lblLike.text = [[Utility sharedInstance] convertNumberIntoDepiction:obj.likesCount];
    cell.btnLike.tag = indexPath.row;
    if ([obj.isLiked isEqualToString:@"0"]) {
        [cell.btnLike setImage:[UIImage imageNamed:@"favourite_unselect"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"favourite_select"] forState:UIControlStateNormal];
    }
    
    
    
    [cell.btnLike addTarget:self action:@selector(likeActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.lblPublished.hidden = YES;
    cell.lblDescription.hidden = YES;
    cell.playerView.hidden = YES;
    if (rowShouldExpand)
    {
    if (indexPath.row == selectedRow)
    {
        cell.lblPublished.hidden = NO;
        cell.lblDescription.hidden = NO;
        cell.playerView.hidden = NO;
//        selectedCell = cell;
        NSString *inDateStr = obj.createdOn;
        NSString *s = @"yyyy-MM-dd";
        NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
        outDateFormatter.dateFormat = s;
        
        outDateFormatter.timeZone = [NSTimeZone localTimeZone];
        
        NSDate *outDate = [outDateFormatter dateFromString:inDateStr];
        
        [outDateFormatter setDateFormat:@"MMM dd, YYYY"];
        cell.lblPublished.text = [NSString stringWithFormat:@"Published on %@",[outDateFormatter stringFromDate:outDate]];
        cell.lblDescription.text = obj.videoDescription;
        
    }
    }
    return cell;
}

#pragma mark- tableView Delegate methods.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // VideoListTableViewCell *cell = (VideoListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //.....for row expanding...//

    [prevCell.playerView stopVideo];
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    if (frame.size.height == normalRowHeight)
    {
        rowShouldExpand = YES;
        indexPathToExpand = indexPath;
    }
    else
    {
        rowShouldExpand = NO;
    }
    
    //selectedCell = cell;
    selectedRow = indexPath.row;
//    [UIView animateWithDuration:0.5 animations:^{
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    }];
    
        //........................//
    if (rowShouldExpand)
        [self performSelector:@selector(play) withObject:nil afterDelay:0];
    else
        [SVProgressHUD dismiss];
//   self.blurView.hidden = NO;
//   [SVProgressHUD showWithStatus:@"loading video please wait"];
}

- (void)play
{
    VideoInfoModel *obj = [arrVideoInfoModelObjects objectAtIndex: indexPathToExpand.row];
    NSString *youtubeVideoID = [self extractYoutubeIdFromLink:obj.videoUrl];
    if (youtubeVideoID)
    {
        VideoListTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPathToExpand];
        NSDictionary *playerVars = @{ @"playsinline" : @0 };
        
        [cell.playerView loadWithVideoId:youtubeVideoID playerVars:playerVars];
        prevCell = cell;
        [SVProgressHUD showWithStatus:@"Loading video"];
       // cell.playerView = playerView;

       // [cell.playerView loadWithVideoId:youtubeVideoID];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (rowShouldExpand)
    {
        if (indexPath.row == selectedRow)
            return UITableViewAutomaticDimension;
    }
    return normalRowHeight;
}

- (NSString *)extractYoutubeIdFromLink:(NSString *)link
{
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return link;
}

-(void)likeActionButton:(UIButton *)sender
{
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn)
    {
        if (!isCallingService) {
            isCallingService = YES;
        VideoInfoModel *obj = [arrVideoInfoModelObjects objectAtIndex:sender.tag];
        if ([obj.isLiked isEqualToString:@"0"])
        {
            [self changeVideoLikeStateTo:videoLikeStateLike ofVideoWithVideoId:obj andButton:sender];
        }
        else
        {
            [self changeVideoLikeStateTo:videoLikeStateUnlike ofVideoWithVideoId:obj andButton:sender];
        }
        }
    }
    else
    {
        //user is not logged in.
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Sign-in required" message:@"Please sign in to like this video." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"Sign-In" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           SignInViewController *signInController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                           [self presentViewController:signInController animated:YES completion:nil];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:signInAction];
        [myAlert addAction:cancelAction];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
}
-(void)changeVideoLikeStateTo:(videoLikeState)LikeState ofVideoWithVideoId:(VideoInfoModel *)video andButton:(UIButton *)button
{
    NSString *serviceVideoLikeOrDislike;
    UIImage *imageToBeSet;
    switch (LikeState)
    {
        case videoLikeStateLike:
        {
            serviceVideoLikeOrDislike = @"SERVICE_USER_VIDEOS_LIKE";
            imageToBeSet = [UIImage imageNamed:@"favourite_select"];
        }
            break;
        case videoLikeStateUnlike:
        {
            serviceVideoLikeOrDislike = @"SERVICE_USER_VIDEOS_UNLIKE";
            imageToBeSet = [UIImage imageNamed:@"favourite_unselect"];
        }
            break;
            
        default:
            break;
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:serviceVideoLikeOrDislike,@"REQUEST_TYPE_SENT",
                          [Utility userId],@"user_id",
                          video.videoId,@"video_id",
                          @"2",@"device_type",
                          @"50",@"device_token"
                          ,nil];
    NSMutableURLRequest *req= [Utility getRequestWithData:[dict mutableCopy]];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          isCallingService = NO;
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
                  switch (LikeState)
                  {
                      case videoLikeStateLike:
                      {
                          video.isLiked = @"1";
                          video.likesCount = [NSString stringWithFormat:@"%d",[video.likesCount integerValue] + 1];
                      }
                          break;
                      case videoLikeStateUnlike:
                      {
                          video.isLiked = @"0";
                          video.likesCount = [NSString stringWithFormat:@"%d",[video.likesCount integerValue] - 1];
                      }
                          break;
                          
                      default:
                          break;
                  }
                  VideoListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
                  cell.lblLike.text = [[Utility sharedInstance] convertNumberIntoDepiction:video.likesCount];
                 // [self initializeVideoInfoModel];
              }
          }
          else
          {//error response.
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
              UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
              [myAlert addAction:action];
              [self presentViewController:myAlert animated:YES completion:nil];
          }
      }] resume];
}

#pragma mark- YTPlayerView Delegate Methods

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
//    self.blurView.hidden = YES;
    [SVProgressHUD dismiss];
    //[self openPlayerViewWithAnimations:YES];
  //[playerView playVideo];
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    switch (error) {
        case kYTPlayerErrorInvalidParam:
            [self.view makeToast:@"invalid parameter error"];
            break;
        case kYTPlayerErrorHTML5Error:
            [self.view makeToast:@"HTML5 Error"];
            break;
        case kYTPlayerErrorVideoNotFound:
            [self.view makeToast:@"Video not found"];
            break;
        case kYTPlayerErrorNotEmbeddable:
            [self.view makeToast:@"video not embeddable"];
            break;
        case kYTPlayerErrorUnknown:
            [self.view makeToast:@"unknown error occured"];
            break;
    
        default:
            break;
    }
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    switch (state)
    {
        case  kYTPlayerStatePlaying:
        [self restrictRotation:YES];
            break;
        case kYTPlayerStateEnded:
        [self restrictRotation:NO];
            break;
        default:
            [self restrictRotation:NO];
            break;
    }
}


-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

#pragma mark- PlayerView View lifecycle.
//-(void)openPlayerViewWithAnimations: (BOOL)animated
//{
//    if (self.playerViewState == playerViewStateClosed)
//    {
//        self.playerViewState = playerViewStateOpen;
//        CGFloat height = self.playerViewMaxHeight;
//        [self increasePlayerViewHeightBy:height WithAnimations:animated];
//    }
//}
//
//-(void)closePlayerViewWithAnimations: (BOOL)animated
//{
//    if (self.playerViewState == playerViewStateOpen)
//    {
//        self.playerViewState = playerViewStateClosed;
//        CGFloat height = self.playerViewMaxHeight;
//        [self decreasePlayerViewHeightBy:height WithAnimations:animated];
//    }
//}

//-(void)increasePlayerViewHeightBy:(CGFloat)Height WithAnimations:(BOOL) animated
//{
//    if (animated)
//    {
//        [UIView animateWithDuration:playerView_animation_duration animations:^
//         {
//             [self increasePlayerViewHeightBy:Height];
//         }];
//    }
//    else
//    {
//        [self increasePlayerViewHeightBy:Height];
//    }
//}
//
//-(void)decreasePlayerViewHeightBy:(CGFloat)Height WithAnimations:(BOOL) animated
//{
//    if (animated)
//    {
//        [UIView animateWithDuration:playerView_animation_duration animations:^
//         {
//             [self decreasePlayerViewHeightBy:Height];
//         }];
//    }
//    else
//    {
//        [self decreasePlayerViewHeightBy:Height];
//    }
//}
//
//-(void)increasePlayerViewHeightBy:(CGFloat)Height
//{
//         self.playerViewHeightConstraint.constant += Height;
//    NSLog(@"%f",_playerViewHeightConstraint.constant);
//         [self.view setNeedsLayout];
//         [self.view layoutIfNeeded];
//}
//
//-(void)decreasePlayerViewHeightBy:(CGFloat)Height
//{
//    self.playerViewHeightConstraint.constant -= Height;
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//}


#pragma mark - UIScrollView optional delegate methods
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    self.previousContentoffset = scrollView.contentOffset.y;
//    NSLog(@"scroll view = %f",scrollView.contentOffset.y);
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"Table view = %f",_tableView.contentOffset.y);
//    NSLog(@"Previous View = %f",_previousContentoffset);
//    
//    if (self.previousContentoffset < self.tableView.contentOffset.y)
//    {
//        //scrolled down
//        if (self.playerViewState == playerViewStateOpen)
//        {
//            NSLog(@" player view height = %f",_playerView.frame.size.height);
//            NSLog(@"player view max height= %f",_playerViewMaxHeight);
//            NSLog(@"player view min height= %f",_playerViewMinHeight);
//            
//            if (self.playerView.frame.size.height <= self.playerViewMaxHeight && self.playerView.frame.size.height >= self.playerViewMinHeight + 2.0)
//            {
//                [self decreasePlayerViewHeightBy:2.0];
//            }
//        }
//    }
//    
//    
//    
//    if (self.previousContentoffset > scrollView.contentOffset.y)
//    {
//        //scrolled up
//        if (self.playerViewState == playerViewStateOpen)
//        {
//            if (self.playerView.frame.size.height <= self.playerViewMaxHeight && self.playerView.frame.size.height >= self.playerViewMinHeight)
//            {
//                [self increasePlayerViewHeightBy:2.0];
//            }
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{//if scrollView will decelarate then following will be done by scrollViewDidEndDecelerating method.
//    if (!decelerate)
//    {
//        if (self.playerViewState == playerViewStateOpen)
//        {
//            if ([self isRowZeroVisible])
//            {//if 1st row is visible then open playerView to its MAX height.
//                CGFloat height = self.playerViewMaxHeight - self.playerView.frame.size.height;
//                [self increasePlayerViewHeightBy:height WithAnimations:YES];
//            }
//        }
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (self.playerViewState == playerViewStateOpen)
//    {
//        if ([self isRowZeroVisible])
//        {//if 1st row is visible then open playerView to its MAX height.
//            CGFloat height = self.playerViewMaxHeight - self.playerView.frame.size.height;
//            [self increasePlayerViewHeightBy:height WithAnimations:YES];
//        }
//    }
//}

//-(BOOL)isRowZeroVisible
//{
//    NSArray *indexes = [self.tableView indexPathsForVisibleRows];
//    for (NSIndexPath *index in indexes)
//    {
//        if (index.row == 0)
//        {
//            return YES;
//        }
//    }
//    
//    return NO;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];

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
