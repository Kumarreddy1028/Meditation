//
//  DashboardViewController.m
//  Meditation
//
//  Created by IOS-01 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "DailyQuoteViewController.h"
#import "DailyHumourViewController.h"
#import "GameScene.h"
#import "ImmersionCampViewController.h"
#import "GlobalMeditationModelClass.h"

#define Logo_size_increase 30

@interface DashboardViewController ()<DashBoardActionDelegate,UITextFieldDelegate>
{
    GameScene *scene;
    UIButton *closeInfoButton;
    UITextView *infoText;
    UIImageView *img;
//    NSTimer *myTimer;
    NSMutableArray *dataArray;
    NSMutableArray *upcomingMeditations, *pastMeditatiions;
}

-(void) infoButtonAction;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    self.noAnimation = false;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([Utility sharedInstance].isFirstTimeShowDashboardAnimation) {
        [self presentScreenWithAnimations];
        [Utility sharedInstance].isFirstTimeShowDashboardAnimation = NO;
    }
    else
    {
        SKView *skView;
        if ([Utility sharedInstance].isDeviceIpad)
            skView = [[SKView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height-300)];
        else
            skView = [[SKView alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height-140)];

        [skView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:skView];
        SKView *sk_view = (SKView *)skView;
        sk_view.showsFPS = NO;
        sk_view.showsNodeCount = NO;
        sk_view.showsQuadCount = NO;
        // Sprite Kit applies additional optimizations to improve rendering performance /
        sk_view.ignoresSiblingOrder = YES;
        if ([Utility sharedInstance].isDeviceIpad)
            scene = [GameScene nodeWithFileNamed:@"GameScene_iPad"];
        else
        {
            if (self.view.frame.size.height <= 500)
            {
                 scene = [GameScene nodeWithFileNamed:@"GameScene4s"];        scene.scaleMode = SKSceneScaleModeAspectFill;
            }
            else{
            scene = [GameScene nodeWithFileNamed:@"GameScene"];        scene.scaleMode = SKSceneScaleModeAspectFill;
            }
        }
        [skView presentScene:scene];
        scene.delegate = self;

        //[self.infoWebView bringSubviewToFront:_skview];
        [skView addSubview:self.onlineUserCount];
        [self.onlineUserCount setUserInteractionEnabled:TRUE];
        [self.onlineUserCount addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoButtonAction)]];
    }


 //   [self serviceCallForOnlineUsers]serviceCallForOnlineUsers;
//    myTimer=[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(userUpdate) userInfo:nil repeats:YES];
    
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//}
//
//
//-(void)userUpdate
//{
//    [self serviceCallForOnlineUsers];
//
//}
//- (void)viewDidDisappear:(BOOL)animated
//{
//    self.skview = nil;
//    scene = nil;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOnlineUsers) name:@"changeOnlineUsersCount" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalMeditaionTimeNotification" object:nil];
    if([Utility sharedInstance].onlineUsers)
    {
        self.onlineUsers.text=  [[Utility sharedInstance] convertNumberIntoDepiction:[Utility sharedInstance].onlineUsers];
    }
    [self serviceCallForGlobalMeditation];
}


-(void) changeServerDate:(NSString *) date {
    scene.str = [Utility timeDifference:[NSDate date] ToDate:date];
    scene.serverDate = date;
    [scene timeUpdate];
}

-(void)serviceCallForGlobalMeditation
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_GLOBAL_MEDITATION_TOPIC" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[Utility userId] forKey:User_Id];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
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
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                  
              }
              else
              {
                  if ([responseObject objectForKey:@"error_code"])
                  {
                      NSString *err=[responseObject objectForKey:@"error_desc"];
                      [self.view makeToast:err];
                      NSLog(@"Error: %@", err);
                  }
                  else if ([responseObject isKindOfClass:[NSDictionary class]])
                  {
                      NSArray *servicesArr=[[NSArray alloc]init];
                      
                      servicesArr=[responseObject objectForKey:@"global_meditation_topics"];
                      if (servicesArr) {
                          BOOL isFound = FALSE;
                          for(int i=0;i<servicesArr.count;i++)
                          {
                              NSMutableDictionary *dic = [servicesArr objectAtIndex:i];
                              GlobalMeditationModelClass *obj=[[GlobalMeditationModelClass alloc]initWithDictionary:dic];
                              obj.startDt = [obj.startDt dateByAddingTimeInterval:(NSTimeInterval)[Utility totalDurationFromString:[dic objectForKey:@"duration"]]];
                              if ([obj.startDt timeIntervalSinceDate:[NSDate date]] >= 0) {
                                  isFound = TRUE;
                                  
                                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                  dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                                  NSString *currentDatestring = [dateFormatter stringFromDate:[NSDate date]];

                                  [self performSelector:@selector(changeServerDate:) withObject:obj.startDate afterDelay:2.0];
                                  [[Utility sharedInstance] setOnlineUsers:obj.meditators];
                                  break;
                              }
                          }
                          if (isFound == FALSE) { // if not found in the list and past meditation is before 72 hours.
                              NSMutableDictionary *dic = [servicesArr lastObject];
                              
                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                              [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                              dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                              NSDate *startDate = [dateFormatter dateFromString:[dic objectForKey:@"start_date"]];
                              startDate =  [startDate dateByAddingTimeInterval:(NSTimeInterval)[Utility totalDurationFromString:[dic objectForKey:@"duration"]]];
                              
                              NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                              [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                              dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                              NSString *currentDatestring = [dateFormatter1 stringFromDate:[dic objectForKey:@"start_date"]];

                              
                              scene.str = [Utility timeDifference:[NSDate date] ToDate:[dic objectForKey:@"start_date"]];

                              if (false == [Utility isPastDateLimitExceeds:[NSDate date] endDate:startDate]) {
                                  GlobalMeditationModelClass *obj1=[[GlobalMeditationModelClass alloc]initWithDictionary:dic];
                                  [[Utility sharedInstance] setOnlineUsers:obj1.meditators];
                                  [[Utility sharedInstance] setIsFinished:TRUE];
                                  [scene timeUpdate];
                              }
                          }
//                          [[Utility sharedInstance] setOnlineUsers:[servicesArr[0] objectForKey:@"meditator_count"]];
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOnlineUsersCount" object:nil];
                          self.onlineUsers.text=  [[Utility sharedInstance] convertNumberIntoDepiction:[Utility sharedInstance].onlineUsers];
                      }
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

-(void) infoButtonAction {
    NSLog(@"%s", __FUNCTION__);
}

-(BOOL) checkforinfoview :(UITouch *) touch {
    CGPoint point = [touch locationInView:self.view];
    BOOL yes = CGRectContainsPoint(self.onlineUserCount.frame, point);
    NSLog(@"bool %d", yes);
    if (yes) {
        [self actionOnNode:@"global_meditation"];
    }
    return yes;
}


- (void)changeOnlineUsers
{
    if([Utility sharedInstance].onlineUsers)
    {
        self.onlineUsers.text=  [[Utility sharedInstance] convertNumberIntoDepiction:[Utility sharedInstance].onlineUsers];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}






-(void)presentScreenWithAnimations
{
    //---------Animations-----//
    
    //taking initial frame of logo and cntainer.
    if ([Utility sharedInstance].isDeviceIpad)
        _skview = [[SKView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-300)];
    else
        _skview = [[SKView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-170)];
    [self.skview setAllowsTransparency:YES];
    [self.skview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.skview];
    CGRect logoImageViewOriginalFrame = self.logoImageView.frame;
    
    CGFloat viewHeight = self.view.frame.size.height;
    //making logo in horizontal and vertical center. Making the logo big initially, it will compress to its original size animatedly.
    CGFloat logoX = self.logoImageView.frame.origin.x;
    if ([Utility sharedInstance].isDeviceIpad)
    {
    CGFloat logoNewHeight = self.logoImageView.frame.size.height + 112 ;
    CGFloat logoNewWidth = self.logoImageView.frame.size.width + 150;
    self.logoImageView.frame = CGRectMake(logoX - 150/2, viewHeight/2 - logoNewHeight/2, logoNewWidth, logoNewHeight);
    }
    else
    {
        CGFloat logoNewHeight = self.logoImageView.frame.size.height + 24;
        CGFloat logoNewWidth = self.logoImageView.frame.size.width + 32;
        self.logoImageView.frame = CGRectMake(logoX - 32/2, viewHeight/2 - logoNewHeight/2, logoNewWidth, logoNewHeight);
    }
    //..................................//
    [UIView animateWithDuration:2.0
                          delay:1.0
                        options: UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         CGRect frame = self.skview.frame;
                         frame.origin.y = self.logoImageView.frame.origin.y + self.logoImageView.frame.size.height;
                         self.skview.frame = frame;
                         SKView *sk_view = (SKView *)_skview;
                         sk_view.showsFPS = NO;
                         sk_view.showsNodeCount = NO;
                         sk_view.showsQuadCount = NO;
                         // Sprite Kit applies additional optimizations to improve rendering performance /
                         sk_view.ignoresSiblingOrder = YES;
                     }
                     completion:^(BOOL finished){
                     
                     }];
    
    //................................//
    
    
    [UIView animateWithDuration:4.0
                          delay:3.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^
     {
         self.logoImageView.frame = logoImageViewOriginalFrame;
         CGRect frame = self.skview.frame;
         if ([Utility sharedInstance].isDeviceIpad)
             frame.origin.y = 300;
         else
             frame.origin.y = 170;

         self.skview.frame = frame;
         SKView *sk_view = (SKView *)_skview;
         sk_view.showsFPS = NO;
         sk_view.showsNodeCount = NO;
         sk_view.showsQuadCount = NO;
         // Sprite Kit applies additional optimizations to improve rendering performance /
         sk_view.ignoresSiblingOrder = YES;
         if ([Utility sharedInstance].isDeviceIpad)
         {
             scene = [GameScene nodeWithFileNamed:@"GameScene_iPad"];
         }
         else
         {
             if (self.view.frame.size.height <= 500)
             {
                 scene = [GameScene nodeWithFileNamed:@"GameScene4s"];        scene.scaleMode = SKSceneScaleModeAspectFill;
             }
             else
             {
                 scene = [GameScene nodeWithFileNamed:@"GameScene"];        scene.scaleMode = SKSceneScaleModeAspectFill;
             }
         }

         scene.scaleMode = SKSceneScaleModeAspectFill;
         [_skview presentScene:scene];
         scene.delegate = self;
     }
    completion:^(BOOL finished){}];
    
}

- (void)actionOnNode:(NSString *)nodeName
{
    NSString *identifier = nil;
    if ([nodeName isEqualToString:@"meditate_now"]) {
        identifier = @"MeditateNowStoryboard";
    }
    else if ([nodeName isEqualToString:@"global_meditation"]) {
        identifier = @"globalMeditation";
    }
    else if ([nodeName isEqualToString:@"vedio"]) {
        identifier = @"videos";
    }
    else if ([nodeName isEqualToString:@"daily_hunter"]) {
        identifier = @"DailyHumour";
    }
    else if ([nodeName isEqualToString:@"daily_quotes"]) {
        identifier = @"DailyQuote";
    }
    else if ([nodeName isEqualToString:@"weekly_wisdom"]) {
        identifier = @"Books";
    }
    else if ([nodeName isEqualToString:@"community"]) {
        identifier = @"News_Events";
        if ([Utility sharedInstance].isDeviceIpad)
        {
            UISplitViewController *splitView = [self.storyboard instantiateViewControllerWithIdentifier:@"SplitView"];
            splitView.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
            splitView.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.window setRootViewController:splitView];
            
            
            UIView *navigationView;
            navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85)];
            navigationView.backgroundColor=[UIColor whiteColor];
            UIImageView *navigationImageView
            ;
            navigationImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, navigationView.frame.size.width, 85)];
            navigationImageView.image=[UIImage imageNamed:@"bg"];
            [navigationImageView setContentMode:UIViewContentModeTop];
            navigationImageView.clipsToBounds=YES;


            UIButton *dashboardBtn;
            
            dashboardBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 15, 55, 55)];
            [dashboardBtn setImage:[UIImage imageNamed:@"GlobalMeditation_dot"]forState:UIControlStateNormal];
            [dashboardBtn addTarget:self action:@selector(ipaddashboardBtnActn) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *titleLbl;
            titleLbl=[[UILabel alloc]initWithFrame:CGRectMake(200, 15, self.view.frame.size.width-400, 55)];
            titleLbl.text=@"news & events";
            titleLbl.backgroundColor=[UIColor clearColor];
            titleLbl.textColor=[UIColor whiteColor];
            [titleLbl setTextAlignment:NSTextAlignmentCenter];
            [titleLbl setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:32]];
            [navigationView addSubview:navigationImageView];
            [navigationView addSubview:titleLbl];
            [navigationView addSubview:dashboardBtn];
            [appDelegate.window addSubview:navigationView];
            return;
        }
    }
    if (identifier.length != 0)
    {
        DailyHumourViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:cont animated:!self.noAnimation];
        self.noAnimation = false;
    }
}


-(void)ipaddashboardBtnActn
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)metuBtnActn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];  
    
}

- (IBAction)infoBtnActn:(UIButton *)sender
{
    self.logoImageView.hidden=YES;
    self.closeBtn.hidden=NO;
    self.infoWebView.hidden=NO;
    self.menuBtn.hidden=YES;
    self.infoBtn.hidden=YES;
    self.skview.hidden=YES;
    [self serviceCallForInfo];
    
//    NSString *str=@"jbfgbijgbdfggb uyg hjk fhj jug h gi dfsg dfjsgdfhjgyf gfgdfkghjdfklhgjdf  hgjdfhjkghjkbfk fdhbfdhjksf dhsbfh";
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

}

- (IBAction)closeButtonActn:(UIButton *)sender {
    self.menuBtn.hidden=NO;
    self.infoBtn.hidden=NO;
    self.skview.hidden=NO;

    self.closeBtn.hidden=YES;
    self.infoWebView.hidden=YES;
    self.logoImageView.hidden=NO;

    

}
//
-(void)serviceCallForInfo
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    [SVProgressHUD show];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"DASHBOARD_INFORMATION" forKey:@"REQUEST_TYPE_SENT"];
    
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          [SVProgressHUD dismissWithDelay:1.0];

          responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
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
