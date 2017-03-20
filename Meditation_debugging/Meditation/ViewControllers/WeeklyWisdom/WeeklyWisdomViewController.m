//
//  WeeklyWisdomViewController.m
//  Meditation
//
//  Created by IOS-2 on 11/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "WeeklyWisdomViewController.h"
#import "SocialShareViewController.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"

@interface WeeklyWisdomViewController ()<UIScrollViewDelegate,UITextViewDelegate>
{
    UIView *calendarView;
    UIButton *calendarModeChangeBtn;
    UILabel *calenderModeChangeLabel;
    UIView *popView;
    int count;
    float x;
    NSDate *todayDate;
    NSString *result;
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    UITapGestureRecognizer *tap;
}
@property (strong, nonatomic)JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic)JTCalendarContentView *calendarContentView;
@property (strong, nonatomic)JTCalendar *calendar;
@end

@implementation WeeklyWisdomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSString *string = [NSString stringWithFormat:@"%ld", (long)day];
    self.calendarCurrentDateOnImageLabel.text=string;
    
    todayDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    result = [formatter stringFromDate:todayDate];
    [self serviceCallForWeeklyWisdom:result];

    count = 0;
    x = .2;
    self.puzzleView.userInteractionEnabled=YES;
    self.weeklyTextView.delegate = self;
    self.weeklyTextView.selectable=NO;
    
    [self.weeklyTextView setTextContainerInset:UIEdgeInsetsMake(15, 10, 5, 10)];
    
    [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x]];

     self.initialContentOffset = self.weeklyTextView.contentOffset.y;


    // Do any additional setup after loading the view.
    
}





-(void)backgroundTap
{
    count = 0;
    x = .2;
    self.previousContentoffset = self.weeklyTextView.contentOffset.y;
    [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x]];
    self.puzzleLbl.alpha =1.0;
    
    self.contentViewTopConstraint.constant=14;
    self.contentView.userInteractionEnabled=YES;
    self.contentView.alpha=1.0;
    [calendarView removeFromSuperview];
    [self.view removeGestureRecognizer:tap];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calendarBtnActn:(id)sender
{
    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)];
    [self.view addGestureRecognizer:tap];
    [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x]];

    self.puzzleLogoImage.alpha = 1;
    if (![calendarView isDescendantOfView:self.view])
    {
        self.previousContentoffset = self.weeklyTextView.contentOffset.y;

        self.contentView.userInteractionEnabled=NO;
        self.contentView.alpha=0.5;
        self.contentViewTopConstraint.constant=139;
        calendarView =[[UIView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 125)];
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
        calenderModeChangeLabel.layer.cornerRadius=2.0;
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
        
        [self.calendar setMenuMonthsView:self.calendarMenuView];
        [self.calendar setContentView:self.calendarContentView];
        [self.calendar setDataSource:self];
         self.calendar.calendarAppearance.isWeekMode = YES;
        [self.calendar reloadAppearance];
        [calendarView addGestureRecognizer:swipeDown];
        [calendarView addGestureRecognizer:swipeUp];
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
        count = 0;
        x = .2;
        self.previousContentoffset = self.weeklyTextView.contentOffset.y;
        [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x]];
        self.puzzleLbl.alpha=1.0;

        self.contentViewTopConstraint.constant=14;
        self.contentView.userInteractionEnabled=YES;
        self.contentView.alpha=1.0;
        [calendarView removeFromSuperview];
         [self.view removeGestureRecognizer:tap];
    }
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

-(void)changeModeBtnAction:(UIButton *)sender
{
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    
    [self transitionExample];
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    //   return (rand() % 10) == 1;
    return 0;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setTimeZone:outputTimeZone];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    result = [outputDateFormatter stringFromDate:date];
    
    NSComparisonResult com = [todayDate compare:date];
    
    if (com == NSOrderedAscending)
    {
        NSString * msg=@"Future Date Can Not Be Allowed";
        //[self.view makeToast:msg];
    }
    else
    {
        NSLog(@"Date: %@", result);
        [self serviceCallForWeeklyWisdom:result];
    }
}


#pragma mark - Transition examples

- (void)transitionExample
{
    CGFloat newHeight = 200;
    
    if(self.calendar.calendarAppearance.isWeekMode)
    {
        newHeight = 75;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         [self.calendar reloadAppearance];
                         self.contentView.frame = CGRectMake(0, newHeight+116, self.view.frame.size.width, self.view.frame.size.height);
                         
                         self.calendarContentView.frame = CGRectMake(0, 25, self.view.frame.size.width, newHeight);
                         calendarView.frame = CGRectMake(0, 64, self.view.frame.size.width, newHeight+55);
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
                                          }];
                     }];
}

#pragma mark - UIScrollView delegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.previousContentoffset = self.weeklyTextView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.previousContentoffset < scrollView.contentOffset.y)
    {
        //scrolled down
        if (count<30 )
        {
            count++;
            [self.puzzleLbl setFrame:CGRectMake(self.puzzleLbl.frame.origin.x, self.puzzleLbl.frame.origin.y-2.5, self.puzzleLbl.frame.size.width,self.puzzleLbl.frame.size.height)];
            [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x+=0.01]];
            self.puzzleLbl.alpha-=0.001;
            
            [self.weeklyTextView setFrame:CGRectMake(self.weeklyTextView.frame.origin.x, self.weeklyTextView.frame.origin.y-2.5, self.weeklyTextView.frame.size.width,self.weeklyTextView.frame.size.height+2.5)];
            [self.puzzleLogoImage setFrame:CGRectMake(0, 0, self.puzzleLogoImage.frame.size.width,self.puzzleLogoImage.frame.size.height-2.5)];
            self.puzzleLogoImage.alpha -= 0.02;
            
        }
        if (count>= 30 && count < 40)
            
        {
            count++;
            [self.weeklyTextView setFrame:CGRectMake(self.weeklyTextView.frame.origin.x, self.weeklyTextView.frame.origin.y-1.0, self.weeklyTextView.frame.size.width,self.weeklyTextView.frame.size.height)];
            [self.puzzleLbl setFrame:CGRectMake(self.puzzleLbl.frame.origin.x, self.puzzleLbl.frame.origin.y-1.0, self.puzzleLbl.frame.size.width,self.puzzleLbl.frame.size.height)];
            [self.puzzleLogoImage setFrame:CGRectMake(0, 0, self.puzzleLogoImage.frame.size.width,self.puzzleLogoImage.frame.size.height-1.0)];
            [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x+=0.01]];
            self.puzzleLogoImage.alpha -= 0.02;
        }
    }
    if (self.previousContentoffset > scrollView.contentOffset.y)
    {
        //scrolled up
        if (count> 30 && count <=40)
        {
            count--;
            [self.weeklyTextView setFrame:CGRectMake(self.weeklyTextView.frame.origin.x, self.weeklyTextView.frame.origin.y+1.0, self.weeklyTextView.frame.size.width,self.weeklyTextView.frame.size.height)];
            [self.puzzleLbl setFrame:CGRectMake(self.puzzleLbl.frame.origin.x, self.puzzleLbl.frame.origin.y+1.0, self.puzzleLbl.frame.size.width,self.puzzleLbl.frame.size.height)];
            [self.puzzleLogoImage setFrame:CGRectMake(0, 0, self.puzzleLogoImage.frame.size.width,self.puzzleLogoImage.frame.size.height+1.0)];
            [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x-=0.01]];
            self.puzzleLogoImage.alpha += 0.02;
        }
        if (count<=30 && count > 0)
        {
            count--;
            [self.puzzleLbl setFrame:CGRectMake(self.puzzleLbl.frame.origin.x, self.puzzleLbl.frame.origin.y+2.5, self.puzzleLbl.frame.size.width,self.puzzleLbl.frame.size.height)];
            [self.puzzleLbl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:x-=0.01]];
            self.puzzleLbl.alpha+=0.001;
            
            [self.weeklyTextView setFrame:CGRectMake(self.weeklyTextView.frame.origin.x, self.weeklyTextView.frame.origin.y+2.5, self.weeklyTextView.frame.size.width,self.weeklyTextView.frame.size.height-2.5)];
            [self.puzzleLogoImage setFrame:CGRectMake(0, 0, self.puzzleLogoImage.frame.size.width,self.puzzleLogoImage.frame.size.height+2.5)];

            self.puzzleLogoImage.alpha += 0.02;
        }
    }
}

- (IBAction)backBtnActn:(id)sender
{
   [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)showShareThisWisdomScreenLPGActn:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)  {
        SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
            cont.navigated = YES;
        cont.titleLabelString = @"share this news";
        cont.textToShare = self.weeklyTextView.text ;
        [self.navigationController pushViewController:cont animated:YES];
    }
}

-(void)serviceCallForWeeklyWisdom:(NSString *)date
{
    if (![Utility isNetworkAvailable]) {
        return;
    }
    CGFloat fontSize;
    if ([Utility sharedInstance].isDeviceIpad) {
        fontSize = 20.0;
    }
    else
        fontSize = 15.0;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_WEEKLY_WISDOM" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[Utility userId] forKey:User_Id];
    [dict setObject:date forKey:@"weeklyWisdom_date"];
    [dict setObject:@"2" forKey:@"device_type"];
    
    [SVProgressHUD show];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          [SVProgressHUD dismiss];
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              if ([responseObject isKindOfClass:[NSArray class]])
                  
              {
                  self.weeklyTextView.text=@"No news availabe for the day";
                  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                  paragraphStyle.lineSpacing = 5.0f;
                  paragraphStyle.paragraphSpacing = 10.0f;
                  
                  NSString *string = self.weeklyTextView.text;
                  NSDictionary *ats = @{
                                        NSFontAttributeName : [UIFont fontWithName:@"santana" size:fontSize],
                                        NSParagraphStyleAttributeName : paragraphStyle,
                                        };
                  
                  self.weeklyTextView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];
                  
                  [self.weeklyTextView setTextColor:[UIColor darkGrayColor]];
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
                      NSArray *news = [responseObject objectForKey:@"news"];
                      if (news.count)
                      {
                          
                      NSDictionary *firstNews = [news firstObject];
                      [self.puzzleLogoImage sd_setImageWithURL:[NSURL URLWithString:[firstNews objectForKey:@"news_image"]] placeholderImage:[UIImage imageNamed:@"header"]];

                      self.weeklyTextView.text=[firstNews objectForKey:@"content"];
                      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                      paragraphStyle.lineSpacing = 5.0f;
                      paragraphStyle.paragraphSpacing = 10.0f;
                      
                      NSString *string = self.weeklyTextView.text;
                      NSDictionary *ats = @{
                                            NSFontAttributeName : [UIFont fontWithName:@"santana" size:fontSize],
                                            NSParagraphStyleAttributeName : paragraphStyle,
                                            };
                      
                      self.weeklyTextView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];

                      [self.weeklyTextView setTextColor:[UIColor darkGrayColor]];
                      self.puzzleLbl.text=[firstNews objectForKey:@"title"];
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

@end
