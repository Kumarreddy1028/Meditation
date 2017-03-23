//
//  DailyHumourViewController.m
//  Meditation
//
//  Created by IOS-2 on 04/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "DailyHumourViewController.h"
#import "SocialShareViewController.h"
#import "UIView+Toast.h"
#import "UIImage+animatedGIF.h"

@interface DailyHumourViewController ()<UIScrollViewDelegate>
{
    NSMutableArray * viewArray;
    UIView * dailyHumourView;
    UILabel *titleLabel;
    UIScrollView * scroll;
    UIView *gifView;
    UIImageView *gifImageView;
    UIButton *shareButton;
    UITextView *humourTextView;
    UIView *calendarView;
    UIButton *calendarModeChangeBtn;
    UILabel *calenderModeChangeLabel;
    CGFloat x,y ;
    CGFloat frameX;
    CGFloat frameY;
    UILongPressGestureRecognizer *longPressGesture;
    CGFloat previousContentoffset;
    CGFloat initialContentOffset;
    NSString *result, *todayDateString;
    NSDate *todayDate;
    NSDate *date1;
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    CGPoint lastContentOffset;
    CGRect frame;
    BOOL last;

    
}
@property (strong, nonatomic)JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic)JTCalendarContentView *calendarContentView;

@property (weak, nonatomic)NSLayoutConstraint *calendarContentViewHeight;

@property (strong, nonatomic)JTCalendar *calendar;
@end

@implementation DailyHumourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    viewArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3", nil];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        x= 75.0;     //padding for UIpageControl

        y=75.0;
        frameX = self.view.frame.size.width;
        frameY = self.view.frame.size.height-135;
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85, frameX, frameY)];

    }
    else
    {
        x= 20.0;     //padding for UIpageControl

        y=20.0;
        frameX = self.view.frame.size.width;
        frameY = self.view.frame.size.height-100;
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, frameX, frameY)];
        
    }
  
    frame=CGRectMake(scroll.frame.origin.x, scroll.frame.origin.y, scroll.frame.size.width, scroll.frame.size.height);
    

    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.backgroundColor = [UIColor clearColor];
    scroll.contentSize = CGSizeMake(frameX, frameY);

    [self.view addSubview: scroll];

   
        for(int i = 0; i < viewArray.count; i++)
    {
        dailyHumourView = [[UIView alloc] init];
        dailyHumourView.frame = CGRectMake(x, 0, frameX-2*y, frameY);
        dailyHumourView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];

        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            humourTextView=[[UITextView alloc]init];
            humourTextView.frame=CGRectMake(0, 60, dailyHumourView.frame.size.width, dailyHumourView.frame.size.height-195);
            titleLabel=[[UILabel alloc]init];
            titleLabel.frame=CGRectMake( 0,0, dailyHumourView.frame.size.width, 60);
            gifView=[[UIView alloc]initWithFrame:CGRectMake(0, dailyHumourView.frame.size.height-135, dailyHumourView.frame.size.width, 135)];
            gifView.backgroundColor=[UIColor whiteColor];
            gifImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, gifView.frame.size.width, 135)];
            shareButton=[[UIButton alloc]initWithFrame:CGRectMake(dailyHumourView.frame.size.width-50,5, 50,50)];
            [humourTextView setTextContainerInset:UIEdgeInsetsMake(25, 25, 30, 30)];
            [titleLabel setFont:[UIFont fontWithName:@"santana" size:30]];
            

        }
        else
        {
            humourTextView=[[UITextView alloc]init];
            humourTextView.frame=CGRectMake(0, 44, dailyHumourView.frame.size.width, dailyHumourView.frame.size.height-80);
            titleLabel=[[UILabel alloc]init];
            titleLabel.frame=CGRectMake( 50,0, dailyHumourView.frame.size.width-100, 44) ;
            gifView=[[UIView alloc]initWithFrame:CGRectMake(0, dailyHumourView.frame.size.height-50, dailyHumourView.frame.size.width, 50)];
            gifView.backgroundColor=[UIColor whiteColor];
            gifImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, gifView.frame.size.width, 50)];
            
            shareButton=[[UIButton alloc]initWithFrame:CGRectMake(dailyHumourView.frame.size.width-40, 6, 30, 30)];
            [humourTextView setTextContainerInset:UIEdgeInsetsMake(5, 10, 5, 10)];
            [titleLabel setFont:[UIFont fontWithName:@"santana" size:20]];
        }
        
        humourTextView.editable=NO;
        humourTextView.bounces=NO;
        humourTextView.selectable = NO;
        humourTextView.text=@"";
        humourTextView.tag=i;
        [humourTextView setTextColor:[UIColor colorWithRed:66/255.0 green:60/255.0 blue:79/255.0 alpha:1]];
    
        longPressGesture=[[UILongPressGestureRecognizer alloc]init];
        longPressGesture.minimumPressDuration = 1.0;
        [longPressGesture addTarget:self action:@selector(showShareThisHumorScreenLPGActn:)];
        
        [shareButton setBackgroundImage:[UIImage imageNamed:@"dailyquote_share"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareBtnActn:) forControlEvents:UIControlEventTouchUpInside];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.text=@"";
        titleLabel.textColor=[UIColor whiteColor];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.tag=i+3;
        gifImageView.tag=i+6;
        [humourTextView addGestureRecognizer:longPressGesture];
        [gifView addSubview:gifImageView];
        [dailyHumourView addSubview:gifView];
        [dailyHumourView addSubview:humourTextView];
        [dailyHumourView addSubview:titleLabel];
        [dailyHumourView addSubview:shareButton];

        [scroll addSubview:dailyHumourView];
        
        x += (frameX-y)+y;

    }
    scroll.contentSize = CGSizeMake(frameX*3, frameY);
    
    
    [scroll setContentOffset:CGPointMake(self.view.frame.size.width*2,0) animated:YES];

    lastContentOffset = CGPointMake(640, 0);
    initialContentOffset = self.view.frame.size.width*2;
    
    humourTextView=(UITextView *)[self.view viewWithTag:2];
    titleLabel=(UILabel *)[self.view viewWithTag:5];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger day = [components day];
    
    
    NSString *string = [NSString stringWithFormat:@"%ld", (long)day];
    
    self.calendarCurrentDateOnImageLabel.text=string;
    
    
    todayDate = [NSDate date];
    
    date1=todayDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    result = [formatter stringFromDate:todayDate];
    todayDateString = result;

    [self serviceCallForDailyHumour:result];

     [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
    // Do any additional setup after loading the view.
}

-(void)backgroundTap
{
    scroll.frame =frame;
    scroll.userInteractionEnabled=YES;
    scroll.alpha=1.0;
    [calendarView removeFromSuperview];
}


-(void)showShareThisHumorScreenLPGActn:(UILongPressGestureRecognizer *)sender
{
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        
//        SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
//        
//        cont.navigated = YES;
//        cont.titleLabelString = @"share this humor";
//        humourTextView=(UITextView *)[self.view viewWithTag:1];
//        cont.textToShare = humourTextView.text ;
//        [self.navigationController pushViewController:cont animated:YES];
//    }
    
}

-(void)shareBtnActn:(UIButton*)sender
{
    NSDateFormatter *dF=[[NSDateFormatter alloc]init];
    [dF setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[dF stringFromDate:date1];
    if ([str isEqualToString:todayDateString])
    {
        humourTextView=(UITextView *)[self.view viewWithTag:2];
    }
    else
    {
        humourTextView=(UITextView *)[self.view viewWithTag:1];
    }
    
    

    
    SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
    cont.navigated = YES;
    
    cont.titleLabelString = @"share this humor";
    cont.textToShare = humourTextView.text ;
    [self.navigationController pushViewController:cont animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // The key is repositioning without animation
  
    previousContentoffset = scrollView.contentOffset.x;
    NSLog(@"first %f",previousContentoffset);
    if (previousContentoffset >self.view.frame.size.width*2-self.view.frame.size.width/2 && previousContentoffset <self.view.frame.size.width*2 + self.view.frame.size.width/2)
    {
        NSLog(@"second %f",previousContentoffset);
        previousContentoffset = self.view.frame.size.width*2;
        
    }
    if (previousContentoffset == initialContentOffset)
    {
        if (last)
        {
            initialContentOffset = self.view.frame.size.width;
            last=NO;
        }
    }
    if (previousContentoffset < initialContentOffset)
    {
        titleLabel.text=@"";
        humourTextView.text=@"";
        gifImageView.image=[UIImage imageNamed:@""];
        humourTextView=(UITextView *)[self.view viewWithTag:1];
        titleLabel=(UILabel *)[self.view viewWithTag:4];
        gifImageView=(UIImageView *)[self.view viewWithTag:7];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:-1];
        NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date1 options:0];
        NSLog(@"Date: %@", selectedDate);
        date1=selectedDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        result = [formatter stringFromDate:selectedDate];
        NSLog(@"Date: %@", result);
        
        [self serviceCallForDailyHumour:result];
        [scroll setContentOffset:CGPointMake(self.view.frame.size.width,0) animated:NO];
        initialContentOffset = self.view.frame.size.width;
        last=NO;
        
    }
    
    if (previousContentoffset > initialContentOffset)
    {
        titleLabel.text=@"";
        humourTextView.text=@"";
        gifImageView.image=[UIImage imageNamed:@""];

        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:1];
        NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date1 options:0];
        NSLog(@"Date: %@", selectedDate);
        
        date1=selectedDate;
        
        NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setTimeZone:outputTimeZone];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        result = [outputDateFormatter stringFromDate:date1];
        
        NSComparisonResult com = [todayDate compare:date1];
        last=NO;
        
        if ([result isEqualToString:todayDateString])
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            result = [formatter stringFromDate:selectedDate];
            
            [self serviceCallForDailyHumour:result];
            [scroll setContentOffset:CGPointMake(self.view.frame.size.width*2,0) animated:NO];
            initialContentOffset = self.view.frame.size.width*2;
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            result = [formatter stringFromDate:selectedDate];
            
            [self serviceCallForDailyHumour:result];
            [scroll setContentOffset:CGPointMake(self.view.frame.size.width,0) animated:NO];
        }
    }
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    //   return (rand() % 10) == 1;
    return 0;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    date1=date;
    
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    result = [outputDateFormatter stringFromDate:date1];
    gifImageView.image=[UIImage imageNamed:@""];

    if ([result isEqualToString:todayDateString])
    {
        [scroll setContentOffset:CGPointMake(self.view.frame.size.width*2,0) animated:NO];
        [self serviceCallForDailyHumour:result];
        last=NO;
        
    }
    else
    {
        [scroll setContentOffset:CGPointMake(self.view.frame.size.width,0) animated:NO];
        [self serviceCallForDailyHumour:result];
        last=YES;
        
        
    }
    
}



- (IBAction)calendarBtnActn:(id)sender
{
    if (![calendarView isDescendantOfView:self.view])
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            scroll.frame = CGRectMake(0, 219, self.view.frame.size.width, scroll.frame.size.height);
            calendarView =[[UIView alloc]initWithFrame:CGRectMake(0,94, self.view.frame.size.width, 125)];
        }
        else
        {
            scroll.frame = CGRectMake(0, 189, self.view.frame.size.width, scroll.frame.size.height);
            calendarView =[[UIView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 125)];
        }
        
        scroll.userInteractionEnabled=NO;
        scroll.alpha=0.5;
        
        calendarView.backgroundColor=[UIColor clearColor];
        
        self.calendarMenuView=[[JTCalendarMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
        
        self.calendarMenuView.backgroundColor=[UIColor whiteColor];
        
        self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 70)];
        self.calendarContentView.backgroundColor=[UIColor whiteColor];
        
        calendarModeChangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,95,self.view.frame.size.width, 30)];
        calendarModeChangeBtn.backgroundColor=[UIColor clearColor];
        [calendarModeChangeBtn addTarget:self action:@selector(changeModeBtnAction:)forControlEvents:UIControlEventTouchUpInside];
        calenderModeChangeLabel=[[UILabel alloc]initWithFrame:CGRectMake(calendarModeChangeBtn.frame.size.width/2-15, calendarModeChangeBtn.frame.size.height/2-2, 30, 4)];
        calenderModeChangeLabel.backgroundColor=[UIColor lightGrayColor];
        calenderModeChangeLabel.layer.cornerRadius=3.0;
        calenderModeChangeLabel.layer.masksToBounds=YES;
        
        
        swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
        self.calendar = [JTCalendar new];
        
        // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
        // Or you will have to call reloadAppearance
        {
            self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
            self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
            self.calendar.calendarAppearance.ratioContentMenu = 1.;
        }
        [calendarView addGestureRecognizer:swipeDown];
        [calendarView addGestureRecognizer:swipeUp];
        [self.calendar setMenuMonthsView:self.calendarMenuView];
        [self.calendar setContentView:self.calendarContentView];
        [self.calendar setDataSource:self];
        self.calendar.calendarAppearance.isWeekMode = NO;
        [self transitionExample];
        [self.calendar reloadAppearance];
        [calendarModeChangeBtn addSubview:calenderModeChangeLabel];
        [calendarView addSubview:calendarModeChangeBtn];
        [calendarView addSubview:self.calendarMenuView];
        [calendarView addSubview:self.calendarContentView];
        
        [self.view addSubview:calendarView];
        [self.calendar setCurrentDate:[NSDate date]];
        [self.calendar reloadData];
    }
    else
    {
        scroll.frame = frame;
        scroll.userInteractionEnabled=YES;
        scroll.alpha=1.0;
        [calendarView removeFromSuperview];
    }
}
#pragma mark - Transition examples

- (void)transitionExample
{
    
    CGFloat newHeight = 200;
    if(self.calendar.calendarAppearance.isWeekMode)
    {
        newHeight = 0;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.calendar reloadAppearance];
                         if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                         {
                             scroll.frame = CGRectMake(0, newHeight+146, self.view.frame.size.width, scroll.frame.size.height);
                             calendarView.frame = CGRectMake(0, 94, self.view.frame.size.width, newHeight+55);
                             
                         }
                         else
                         {
                             scroll.frame = CGRectMake(0, newHeight+116, self.view.frame.size.width, scroll.frame.size.height);
                             
                             calendarView.frame = CGRectMake(0, 64, self.view.frame.size.width, newHeight+55);
                             
                         }
                         
                         self.calendarContentView.frame = CGRectMake(0, 25, self.view.frame.size.width, newHeight);
                         calendarModeChangeBtn.frame = CGRectMake(0, newHeight+25, self.view.frame.size.width, 30);
                         
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                              if(self.calendar.calendarAppearance.isWeekMode)
                                              {
                                                  scroll.frame = frame;
                                                  scroll.userInteractionEnabled=YES;
                                                  scroll.alpha=1.0;
                                                  [calendarView removeFromSuperview];
                                              }
                                              
                                          }];
                     }];
}

-(void)serviceCallForDailyHumour:(NSString *)date
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    NSString *Value = [Utility userId];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_DAILY_HUMOR" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:Value forKey:@"user_id"];
    [dict setObject:date forKey:@"humor_date"];
    [dict setObject:@"2" forKey:@"device_type"];
    
    [SVProgressHUD show];

    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    humourTextView.text=@"";
    titleLabel.text=[Utility changeDateFormat:result];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if ([responseObject isKindOfClass:[NSDictionary class]])
          {
              responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
          }
          [SVProgressHUD dismiss];;
          if (!error)
          {
              
              NSLog(@"Reply JSON: %@", responseObject);
              
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                  NSComparisonResult com = [todayDate compare:date1];
                  NSDateFormatter *dF=[[NSDateFormatter alloc]init];
                  [dF setDateFormat:@"yyyy-MM-dd"];
                  NSString *str=[dF stringFromDate:date1];
                  if ([str isEqualToString:todayDateString])
                  {
                      humourTextView=(UITextView *)[self.view viewWithTag:2];
                      titleLabel=(UILabel *)[self.view viewWithTag:5];

                      humourTextView.text=@"No humor available for this day. Select any other day or slide to your right to read from the numerous past ones.";
                      NSString *combined = [NSString stringWithFormat:@"today %@", [Utility changeDateFormat:str]];
                      titleLabel.text=@"today";
                      [scroll setContentOffset:CGPointMake(self.view.frame.size.width*2,0) animated:NO];
                      initialContentOffset = self.view.frame.size.width*2;
                      
                  }
                  else
                  {
                      humourTextView=(UITextView *)[self.view viewWithTag:1];
                      titleLabel=(UILabel *)[self.view viewWithTag:4];
                      [scroll setContentOffset:CGPointMake(self.view.frame.size.width,0) animated:NO];
                      humourTextView.text=@"No humor available for this day. Select any other day or slide to your right to read from the numerous past ones.";
                      titleLabel.text=[Utility changeDateFormat:str];
                  }
                  
              }
              else{

              if ([responseObject objectForKey:@"error_code"])
              {
                  NSString *err=[responseObject objectForKey:@"error_desc"];
                  
                  [self.view makeToast:err];
                  
                  
                  NSLog(@"Error: %@", err);
                  
                  
              }
              
              else if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                  NSComparisonResult com = [todayDate compare:date1];
                  NSString *str=[responseObject objectForKey:@"published_on"];
                  if ([str isEqualToString:todayDateString])
                  {
                      
                      humourTextView=(UITextView *)[self.view viewWithTag:2];
                      titleLabel=(UILabel *)[self.view viewWithTag:5];
                      gifImageView=(UIImageView *)[self.view viewWithTag:8];

                      humourTextView.attributedText=[Utility changeLineSpacing:[responseObject objectForKey:@"content"]];
                      [humourTextView setTextContainerInset:UIEdgeInsetsMake(15, 14, 15, 14)];
                      humourTextView.textColor=[UIColor colorWithRed:66/255.0 green:60/255.0 blue:79/255.0 alpha:1];
                      NSString *combined = [NSString stringWithFormat:@"today %@", [Utility changeDateFormat:str]];
                      titleLabel.text=@"today";
                      NSURL *url = [NSURL URLWithString:[responseObject objectForKey:@"banner"]];
                      gifImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
                      [scroll setContentOffset:CGPointMake(self.view.frame.size.width*2,0) animated:NO];
                      initialContentOffset = self.view.frame.size.width*2;
                    
                      
                  }
                  else
                  {
                      humourTextView=(UITextView *)[self.view viewWithTag:1];
                      titleLabel=(UILabel *)[self.view viewWithTag:4];
                      gifImageView=(UIImageView *)[self.view viewWithTag:7];

                     humourTextView.attributedText=[Utility changeLineSpacing:[responseObject objectForKey:@"content"]];
                      [humourTextView setTextContainerInset:UIEdgeInsetsMake(15, 14, 15, 14)];
                      humourTextView.textColor=[UIColor colorWithRed:66/255.0 green:60/255.0 blue:79/255.0 alpha:1];
                      NSURL *url = [NSURL URLWithString:[responseObject objectForKey:@"banner"]];
                      gifImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
                      [scroll setContentOffset:CGPointMake(self.view.frame.size.width,0) animated:NO];
                      titleLabel.text=[Utility changeDateFormat:str];
                  }

              }
              }
              if ([Utility sharedInstance].isDeviceIpad) {
                  [humourTextView setFont:[UIFont fontWithName:@"santana" size:24.0]];
              }
              else
              {
                  [humourTextView setFont:[UIFont fontWithName:@"santana" size:17.0]];
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        if(!self.calendar.calendarAppearance.isWeekMode)
        {
            [self transitionExample];
        }
        
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if(self.calendar.calendarAppearance.isWeekMode)
        {
            [self transitionExample];
        }
        
    }
}

- (IBAction)backBtnActn:(id)sender
{
 [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];

}


-(void)changeModeBtnAction:(UIButton *)sender
{
//    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
//    
//    [self transitionExample];
}

- (IBAction)dashBoardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}
@end
