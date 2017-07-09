 //
//  GlobalMeditationViewController.m
//  Meditation
//
//  Created by IOS-01 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "GlobalMeditationViewController.h"
#import "GlobalMeditationTableViewCell.h"
#import "GlobalMeditationModelClass.h"
#import "CustomMkAnnotationViewForGlobalMeditation.h"
#import "MeditationProgressViewController.h"
#import "MeditationMusicViewController.h"
#import "MDLabel.h"
#import "GlobalMeditationPostTableViewCell.h"
#import "GlobalMeditationHeaderView.h"
#import "GlobalMeditationPostHeaderView.h"
#import "GlobalMeditationMapCell.h"
#define CUR_MEDITATION_LIMIT 2
@interface GlobalMeditationViewController ()<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate, GlobalMeditationPostTableViewCellDelegate, GlobalMeditationHeaderViewDelegate, GlobalMeditationMapCellDelegate>
{

    NSString *str;
    NSTimer *myTimer;
    CLLocationCoordinate2D currentCor;
    CLLocationDistance radius;
    NSMutableArray *latLongArray;
    NSInteger locationIndex;
    BOOL isRegionWise, flag;
    NSDate *dateFromString;
    CLLocationCoordinate2D newCenter;
    int currentZoomLevel;
    BOOL isUpcomingSelected, isPastSelected, updateFlag;
  
}
@end

@implementation GlobalMeditationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapViewOutlet.delegate=self;
    currentCor = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", currentCor.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", currentCor.longitude];
    
    NSLog(@"*dLatitude : %@", latitude);
    NSLog(@"*dLongitude : %@",longitude);
    self.mapSuperView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -150);
    [self serviceCallForGlobalMeditation];
    
    flag = NO;
    currentZoomLevel = 0;
    newCenter.latitude=0;
    newCenter.longitude=0;
    self.mapViewOutlet.showsUserLocation=YES;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        self.btnJoin.layer.cornerRadius=10.0;
        [self.infoTextView setTextContainerInset:UIEdgeInsetsMake(50, 50, 60, 60)];
        [self.infoTextView setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:20.0]];
    }
    else
    {
        self.btnJoin.layer.cornerRadius=5.0;
        [self.infoTextView setTextContainerInset:UIEdgeInsetsMake(25, 30, 25, 30)];
        [self.infoTextView setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:16.0]];
    }
   
    self.btnJoin.clipsToBounds=YES;
    [Utility sharedInstance].isJoiningMeditation = YES;
//    [[Utility sharedInstance] getCurrentLocationAndRegisterDeviceToken];

    [self.tableViewOutlet registerNib:[UINib nibWithNibName:@"GlobalMeditationPostTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GlobalMeditationPostTableViewCell"];
    [self.tableViewOutlet registerNib:[UINib nibWithNibName:@"GlobalMeditationHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"GlobalMeditationHeaderView"];
    [self.tableViewOutlet registerNib:[UINib nibWithNibName:@"GlobalMeditationPostHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"GlobalMeditationPostHeaderView"];
    [self.tableViewOutlet registerNib:[UINib nibWithNibName:@"GlobalMeditationMapCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GlobalMeditationMapCell"];

//    [self.tableViewOutlet reloadData];
    [SVProgressHUD show];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [myTimer invalidate];
    myTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLatestTopicDetails
{
//    NSIndexPath *indexpath = [NSIndexPath indexPathWithIndex:0];

//    [self.tableViewOutlet reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath,nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableViewOutlet reloadData];

    return;
    GlobalMeditationModelClass *obj=[_upcomingMeditations firstObject];
    if (!obj) {
        if ([_pastMeditatiions count]) {
            obj = [_pastMeditatiions lastObject];
        }
    }
    if (obj == nil) {
        return;
    }
    if ([obj.isJoined isEqualToString:@"already joined"])
    {
        [self.btnJoin setTitle:@"unjoin" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnJoin setTitle:@"join" forState:UIControlStateNormal];
    }
    
//    NSDate *dateNew = [Utility getDateFromString:obj.duration];
//    NSDate *startDate = [NSDate dateWithTimeInterval:<#(NSTimeInterval)#> sinceDate:<#(nonnull NSDate *)#>]
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *dateFromAString = [dateFormatter dateFromString:obj.startDate];
    
//    NSString *remainingDuration = [Utility remaningTime:[NSDate date] endDate:dateFromAString];
    
//    NSLog(@"strings remaining duration %@", remainingDuration);
    str = [Utility timeDifference:[NSDate date] ToDate:obj.startDate];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter1.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *startingdate = [dateFormatter1 dateFromString:obj.startDate];

    NSTimeInterval duration = [Utility totalDurationFromString:obj.duration];
    
    NSDate *finishedDate = [startingdate dateByAddingTimeInterval:duration];
    NSDate *CurrentDate = [NSDate date];
//    NSLog(@"difference %f",[Utility getTimeDifference:obj.startDate]);
    //[self timeUpdate];
    
    
    
    
    
    if (([startingdate compare:CurrentDate] == NSOrderedDescending) && (![obj isEqual:[_pastMeditatiions lastObject]])) {
        if ([obj.isJoined isEqualToString:@"already joined"])
        {
            [self.btnJoin setTitle:@"unjoin" forState:UIControlStateNormal];
        }
        else
        {
            [self.btnJoin setTitle:@"join" forState:UIControlStateNormal];
        }
        str=[Utility timeDifference:[NSDate date] ToDate:obj.startDate];
        self.timeLeft.text=[Utility changeTimeformat:str];
                 //[myTimer invalidate];
    } else if ( ( [startingdate compare:CurrentDate] == NSOrderedAscending) && ([finishedDate compare:CurrentDate] == NSOrderedDescending) ) {
        NSLog(@"finishedDate1 is later than CurrentDate");
        self.timeLeft.text=@"started";
        [self.btnJoin setTitle:@"Begin" forState:UIControlStateNormal];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSString *currentDateString = [Utility getUTCFormateDate:[NSDate date]];
        NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
        NSDate *startDt = [obj.startDt dateByAddingTimeInterval:[Utility totalDurationFromString:obj.duration]];
        NSTimeInterval duration = 0 - [currentDate timeIntervalSinceDate:obj.startDt];
        NSLog(@"duration %fl, Cduration %@", duration, obj.duration);
        int timeToleave = [Utility totalDurationFromString:obj.duration];
        NSLog(@"Timetoleave1 %d", timeToleave);
        [self performSelector:@selector(removeUpdatedMediation:) withObject:obj afterDelay:duration];


    }
    if ([finishedDate compare:CurrentDate] == NSOrderedAscending) {
        if ([obj isEqual:[_pastMeditatiions lastObject]]) {
            NSLog(@"finishedDate is earlier than CurrentDate");
            self.timeLeft.text=@"Finished";
            [self.btnJoin setTitle:@"Finished" forState:UIControlStateNormal];
            GlobalMeditationModelClass *obj=[_dataArray objectAtIndex:0];
            str=[Utility timeDifference:[NSDate date] ToDate:obj.startDate];
            self.timeLeft.text=[Utility changeTimeformat:str];
            [[Utility sharedInstance] setIsFinished:TRUE];
        }
    }
    
    
    
    [self.countries setText:obj.countries];
    [self.meditatorsCount setText:[[Utility sharedInstance] convertNumberIntoDepiction:obj.meditators]];
    
    NSString *inDateStr = obj.startDate;
    
    NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
    outDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    outDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *outDate = [outDateFormatter dateFromString:inDateStr];
    [outDateFormatter setDateFormat:@"dd MMM, hh:mma"];
    outDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    NSString *stringDate = [outDateFormatter stringFromDate:outDate];
    
    stringDate=[[[NSString stringWithFormat:@"(%@ )",stringDate]stringByReplacingOccurrencesOfString:@"AM" withString:@"am"]stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    
    [self.istDateTime setText:stringDate];
    
}

#pragma mark-tableView dataSource method-

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    if (section == 0 && isUpcomingSelected) {
        return _upcomingMeditations.count>CUR_MEDITATION_LIMIT?CUR_MEDITATION_LIMIT:_upcomingMeditations.count;
    } else if (section == 1 && isPastSelected) {
        return _pastMeditatiions.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlobalMeditationModelClass *obj;
    UITableViewCell *targetCell;
    obj = indexPath.section == 0 ? _upcomingMeditations[indexPath.row] : _pastMeditatiions[indexPath.row];
    
    NSString *inDateStr = obj.startDate;
    NSString *s = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
    outDateFormatter.dateFormat = s;
    outDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *outDate = [outDateFormatter dateFromString:inDateStr];
    [outDateFormatter setDateFormat:@"dd-MMM-yy"];
    outDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    NSString *stringDate = [outDateFormatter stringFromDate:outDate];
    [outDateFormatter setDateFormat:@"hh:mma"];
    
    NSString *stringTime = [outDateFormatter stringFromDate:outDate];
    NSString *strDateTime=[[[NSString stringWithFormat:@"%@ at %@ ",stringDate,stringTime]stringByReplacingOccurrencesOfString:@"AM" withString:@"am"]stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
                        GlobalMeditationMapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellmapid"];
            cell.viewcontroller = self;
            
//            cell.mapViewOutlet.delegate = cell;
            
//            self.mapViewOutlet.showsUserLocation = YES;
            cell.respDict = self.responseDict;
            cell.mapViewOutlet.delegate = self;
            
//            cell.mapViewOutlet.showsUserLocation = YES;
            [cell.btnJoin addTarget:self action:@selector(btnJoinActn:) forControlEvents:UIControlEventTouchUpInside];
            [cell configureCell];
            
                        targetCell = cell;
//            GlobalMeditationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
//            targetCell = cell;
            
                    }
        else
            {
        
        GlobalMeditationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
        targetCell = cell;
        cell.pinBtn.tag=indexPath.row;
        
        cell.labelNumberOfMeditators.text=[[[Utility sharedInstance] convertNumberIntoDepiction:obj.meditators]stringByAppendingString:@""];
        cell.joinBtn.tag = indexPath.row;
        
        cell.labelTimingAndDate.text=strDateTime;
        //    cell.labelNumberOfMeditators.text = obj.meditators;
        
        if (![obj.isJoined isEqualToString:@"already joined"] || obj.isJoined == nil) {
            [cell.pinBtn setTitle:@"join" forState:UIControlStateNormal];
//            [cell.pinBtn setImage:[UIImage imageNamed:@"pin_unselect"] forState:UIControlStateNormal];
            [cell.joinBtn setTitle:@"join" forState:UIControlStateNormal];
        }
        else
        {
//            [cell.pinBtn setImage:[UIImage imageNamed:@"pin_select"] forState:UIControlStateNormal];
            [cell.pinBtn setTitle:@"unjoin" forState:UIControlStateNormal];

            [cell.joinBtn setTitle:@"unjoin" forState:UIControlStateNormal];

        }
        
    }
    } else {
        GlobalMeditationPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GlobalMeditationPostTableViewCell"];
        targetCell = cell;
        cell.delegate = self;
        cell.playButton.tag=indexPath.row;
        
        cell.labelNumberOfMeditators.text=[[[Utility sharedInstance] convertNumberIntoDepiction:obj.meditators]stringByAppendingString:@" meditators"];
        
        cell.labelTimingAndDate.text=strDateTime;
    }
    return targetCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
//        if ((section == 1)&&(_pastMeditatiions.count == 0)) {
//            return 70;
//        }
        
        return 70;
        

    } else {
        
//        if ((section == 1)&&(_pastMeditatiions.count == 0)) {
//            return 60;
//        }

        return 60;
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                return 560;
            }
            else {
                return 340;
            }
            return 560;
        } else {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                            return 80;
            } else {
                return 60;
            }
        }
    }
    else {
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    GlobalMeditationHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GlobalMeditationHeaderView"];
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
//        
//    } else {
//        [view.te setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:10.0f]];
//    }

    view.type = (GlobalMeditationHeaderViewType)section;
    view.delegate = self;
    if (view.type == GlobalMeditationHeaderViewTypeUpcomming) {
        view.isSelected = isUpcomingSelected;
        
        
    } else {
        view.isSelected = isPastSelected;
//        if (_pastMeditatiions.count == 0) {
//            GlobalMeditationPostHeaderView *view1 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GlobalMeditationPostHeaderView"];
//            //            GlobalMeditationPostHeaderView *view1 = [[GlobalMeditationPostHeaderView alloc] initWithReuseIdentifier:@"GlobalMeditationPostHeaderView"];
//            return view1;
//        }

    }
//    MDLabel *label = [[MDLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30)];
//    label.leftPading = 17;
//    [label setTextColor:[UIColor whiteColor]];
//    [label setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:16.0]];
//    if (section == 0) {
//        [label setText:@"Upcoming Meditations"];
//    } else {
//        [label setText:@"Past Meditations"];
//    }
    
    return view;
}

- (void)didSelectedHeader:(GlobalMeditationHeaderView *)view type:(GlobalMeditationHeaderViewType)type {
    if (type == GlobalMeditationHeaderViewTypeUpcomming) {
        if ([_upcomingMeditations count] == 0) {
            return;
        }
        isUpcomingSelected = !isUpcomingSelected;
    } else {
        if ([_pastMeditatiions count] == 0) {
            return;
        }
        isPastSelected = !isPastSelected;
    }

    //[self.tableViewOutlet reloadSections:[NSIndexSet indexSetWithIndex:type] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableViewOutlet reloadData];
    
}



- (void)pastMeditationCellDidSelectPlay:(GlobalMeditationPostTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableViewOutlet indexPathForCell:cell];
    GlobalMeditationModelClass *obj = _pastMeditatiions[indexPath.row];
    
    MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
    BOOL guided;
        cont.imageName=obj.musicImageName;
        guided = NO;
        if ([obj.musicFileName isEqualToString:@""])
        {
            cont.musicName=obj.musicfilemp3;
        }
        else
        {
            cont.musicName=obj.musicFileName;
        }
        cont.duration=obj.duration;
        cont.topicId=obj.topicId;
        cont.guided=guided;
        cont.imageName = obj.musicImageName;
        [self.navigationController pushViewController:cont animated:YES];
    
}

-(void)timeUpdate
{
    return;
    if ([str isEqualToString:@"00:00:00:00"] || [str isEqualToString:@"00:00:00"])
    {
        self.timeLeft.text=@"started";
            [self.btnJoin setTitle:@"Begin" forState:UIControlStateNormal];
            [myTimer invalidate];
    }
    else
    {
        GlobalMeditationModelClass *obj=[_dataArray objectAtIndex:0];
        str=[Utility timeDifference:[NSDate date] ToDate:obj.startDate];
        self.timeLeft.text=[Utility changeTimeformat:str];
        
//        NSDate *now = [NSDate date];
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        if ([str isEqualToString:@"03:00:00:00"])
//        {
//            notification.fireDate = now;
//            notification.alertBody = @"Global Meditation Will Be Started After 3 Days!";
//        }
//        if ([str isEqualToString:@"02:00:00:00"])
//        {
//            notification.fireDate = now;
//            notification.alertBody = @"Global Meditation Will Be Started After 2 Days!";
//        }
//        if ([str isEqualToString:@"01:00:00:00"])
//        {
//            notification.fireDate = now;
//            notification.alertBody = @"Global Meditation Will Be Started After a Day";
//        }
//        if ([str isEqualToString:@"00:00:30:00"])
//        {
//            notification.fireDate = now;
//            notification.alertBody = @"Global Meditation Will Be Started After 30 Minutes!";
//        }
//        if ([str isEqualToString:@"00:00:15:00"])
//        {
//            notification.fireDate = now;
//            notification.alertBody = @"Global Meditation Will Be Started After 15 Minutes!";
//        }
//        notification.timeZone = [NSTimeZone defaultTimeZone];
//        notification.soundName=UILocalNotificationDefaultSoundName;
//        notification.applicationIconBadgeNumber = 1;
    }

    
}
//-(NSString *)changeTimeformat:(NSString*)time
//{
//    NSArray *items = [time componentsSeparatedByString:@":"];
//    NSString *drtnDay=[items objectAtIndex:0];
//    NSString *drtnHour=[items objectAtIndex:1];
//    NSString *drtnMin=[items objectAtIndex:2];
////    NSString *drtnSec=[items objectAtIndex:3];
//    NSString *finalDrtn=[NSString stringWithFormat:@"%dd %dh %dm",[drtnDay intValue],[drtnHour intValue],[drtnMin intValue]];
//    
//    return finalDrtn;
//}

#pragma mark-Button Actions-


- (IBAction)btnJoinActn:(UIButton *)sender
{
    if ([sender titleForState:UIControlStateNormal] == nil) {
        return;
    }
    self.btnJoin = sender;
//    GlobalMeditationModelClass *currentTopic = [dataArray objectAtIndex:0];
//
//    MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
//    cont.musicName=currentTopic.musicFileName;
//    cont.imageName=currentTopic.musicImageName;
//
//    NSString *str=currentTopic.duration;
//    cont.duration=@"00:05:20";

//    cont.meditators = currentTopic.meditators;
//    cont.countries = currentTopic.countries;
//    [self.navigationController pushViewController:cont animated:YES];
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    
    if (loggedIn)
    {
        NSInteger index = 0;
        if (sender.tag != -1) {
            index = sender.tag;
        }
        GlobalMeditationModelClass *currentTopic = [_upcomingMeditations objectAtIndex:index];
            if ([self.btnJoin.titleLabel.text isEqualToString:@"Begin"])
            {
                if ([currentTopic.isJoined isEqualToString:@"already joined"])
                {//user has joined.
                    
                    MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
                    if ([currentTopic.musicFileName isEqualToString:@""])
                    {
                        cont.musicName=currentTopic.musicfilemp3;
                    }
                    else
                    {
                        cont.musicName=currentTopic.musicFileName;
                    }
                    cont.global = YES;
                    cont.color=currentTopic.colorCode;
                    cont.imageName=currentTopic.musicImageName;
                    cont.duration=currentTopic.duration;
//                    cont.meditators = currentTopic.meditators;
//                    cont.countries = currentTopic.countries;
                    [self.navigationController pushViewController:cont animated:YES];
                }
                else
                {
//                    NSString *string = @"You haven’t joined this meditation.";
//                    [self.view makeToast:string];
                    [self serviceCallForGlobalMeditationJoin:index];
                    MeditationMusicViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Musicstoryboard"];
                    if ([currentTopic.musicFileName isEqualToString:@""])
                    {
                        cont.musicName=currentTopic.musicfilemp3;
                    }
                    else
                    {
                        cont.musicName=currentTopic.musicFileName;
                    }
                    cont.global = YES;
                    cont.color=currentTopic.colorCode;
                    cont.imageName=currentTopic.musicImageName;
                    cont.duration=currentTopic.duration;
                    //                    cont.meditators = currentTopic.meditators;
                    //                    cont.countries = currentTopic.countries;
                    [self.navigationController pushViewController:cont animated:YES];

                }
              
            }
            else
            {
                if ([currentTopic.isJoined isEqualToString:@"already joined"])
                {//user has joined.
                    NSLog(@"User has joined. Now unjoin %lu", (long)index);
                    [self serviceCallForGlobalMeditationUnJoin:index];
                }
                else
                {
                    NSLog(@"User has NOT joined. Now join %lu", (long)index);
                    [self serviceCallForGlobalMeditationJoin:index];
                }

            }
    }
    else
    {
        //user is not logged in.
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Sign-in required" message:@"Please sign-in to join this meditation." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"Sign-in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           UIViewController *signInController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                           [self presentViewController:signInController animated:YES completion:nil];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:signInAction];
        [myAlert addAction:cancelAction];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
}
- (IBAction)btnMenuActn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}

- (IBAction)pinBtnActn:(id)sender
{
    UIButton *button = sender;
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn)
    {
         GlobalMeditationModelClass *obj = [_upcomingMeditations objectAtIndex:button.tag];
        if (![obj.isJoined isEqualToString:@"already joined"])
        {
            [self changeRowLikeStateTo:rowLikeStateLike ofRowWithTopicId:obj andButton:button];
        }
        else
        {
            [self changeRowLikeStateTo:rowLikeStateUnlike ofRowWithTopicId:obj andButton:button];
        }
    }
    else
    {
        //user is not logged in.
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Sign-in required" message:@"Please sign-in to join this global event." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"Sign-in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           UIViewController *signInController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                           [self presentViewController:signInController animated:YES completion:nil];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:signInAction];
        [myAlert addAction:cancelAction];
        [self presentViewController:myAlert animated:YES completion:nil];

}
}

#pragma mark-Service Calling Methods-

-(void)changeRowLikeStateTo:(rowLikeState)LikeState ofRowWithTopicId:(GlobalMeditationModelClass *)topic andButton:(UIButton *)button
{
    UIImage *imageToBeSet;
    NSMutableDictionary *dict;
    NSString *country =[Utility sharedInstance].country;
    if ([country isKindOfClass:[NSNull class]] || country == nil) {
        country = @"";
    }
    switch (LikeState)
    {
            
        case rowLikeStateLike:
        {
            dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"SERVICE_USER_GLOBAL_MEDITATION_REGISTRATION" forKey:@"REQUEST_TYPE_SENT"];
            [dict setObject:[Utility userId] forKey:User_Id];
            [dict setObject:topic.topicId forKey:@"topic_id"];
            [dict setObject:[NSString stringWithFormat:@"%f",[Utility sharedInstance].annotationCoord.latitude] forKey:@"latitude"];
            [dict setObject:[NSString stringWithFormat:@"                           %f",[Utility sharedInstance].annotationCoord.longitude] forKey:@"longitude"];
            [dict setObject:country forKey:@"country"];

            //imageToBeSet = [UIImage imageNamed:@"pin_select"];
            

        }
            break;
        case rowLikeStateUnlike:
        {
            dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"SERVICE_USER_GLOBAL_MEDITATION_UNREGISTRATION" forKey:@"REQUEST_TYPE_SENT"];
            [dict setObject:[Utility userId] forKey:User_Id];
            [dict setObject:topic.topicId forKey:@"topic_id"];
            [dict setObject:@"2" forKey:@"device_type"];
            [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
//            imageToBeSet = [UIImage imageNamed:@"pin_unselect"];
        }
            break;
            
        default:
            break;
    }
    
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    
    [SVProgressHUD show];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      { if ([responseObject isKindOfClass:[NSDictionary class]])
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
                      [button setImage:imageToBeSet forState:UIControlStateNormal];
                      switch (LikeState)
                      {
                          case rowLikeStateLike:
                          {
                              [self.view makeToast:@"You have joined this meditation"];
                          }
                              break;
                          case rowLikeStateUnlike:
                          {
                              [self.view makeToast:@"You have left this meditation"];
                          }
                              break;
                              
                          default:
                              break;
                      }
                      [self serviceCallForGlobalMeditation];
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
    
}

-(void) removeUpdatedMediation: (GlobalMeditationModelClass *) obj {
    NSLog(@"%s", __FUNCTION__);

    
    for (GlobalMeditationModelClass *objreal in _pastMeditatiions) {
        if ([objreal isEqual:obj]) {
            return;
        }
    }
    [_upcomingMeditations removeObject:obj];
    [_pastMeditatiions addObject:obj];
    [_tableViewOutlet reloadData];
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
//                          [[Utility sharedInstance] setOnlineUsers:[servicesArr[0] objectForKey:@"meditator_count"]];
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOnlineUsersCount" object:nil];

                          _dataArray=[NSMutableArray new];
                          _upcomingMeditations = [NSMutableArray new];
                          
                          _pastMeditatiions = [NSMutableArray new];
                          for(NSDictionary *dic in servicesArr)
                          {
                              GlobalMeditationModelClass *obj=[[GlobalMeditationModelClass alloc]initWithDictionary:dic];
                              
                              [_dataArray addObject:obj];
                              obj.startDt = [obj.startDt dateByAddingTimeInterval:(NSTimeInterval)[Utility totalDurationFromString:obj.duration]];
                              if ([obj.startDt timeIntervalSinceDate:[NSDate date]] >= 0) {
                                  [_upcomingMeditations addObject:obj];
                                  isUpcomingSelected = TRUE;
                              } else {
                                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                  dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                                  NSDate *startDate = [dateFormatter dateFromString:[dic objectForKey:@"start_date"]];
                                  // Meditation past date checking(more than 3 days not considering the event)
                                  if (false == [Utility isPastDateLimitExceeds:[NSDate date] endDate:startDate]) {
                                      [_pastMeditatiions addObject:obj];
                                      isPastSelected = FALSE;
                                  }
                              }
                          }
                          myTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setLatestTopicDetails) userInfo:nil repeats:YES];
                          [myTimer fire];
//                          [self.tableViewOutlet reloadData];
//                          [self.tableViewOutlet reloadRowsAtIndexPaths:<#(nonnull NSArray<NSIndexPath *> *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]
                          [self serviceCallForLatLong];

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


-(void)serviceCallForGlobalMeditationJoin:(NSInteger) index
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    NSString *country =[Utility sharedInstance].country;
    if ([country isKindOfClass:[NSNull class]] || country == nil) {
        country = @"";
    }
    GlobalMeditationModelClass *obj = [_upcomingMeditations objectAtIndex:index];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_GLOBAL_MEDITATION_REGISTRATION" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[Utility userId] forKey:User_Id];
    [dict setObject:obj.topicId forKey:@"topic_id"];
    [dict setObject:[NSString stringWithFormat:@"%f",[Utility sharedInstance].annotationCoord.latitude] forKey:@"latitude"];
    [dict setObject:[NSString stringWithFormat:@"%f",[Utility sharedInstance].annotationCoord.longitude] forKey:@"longitude"];
    [dict setObject:country forKey:@"country"];

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
                      [self.view makeToast:@"You have joined this meditation."];
                      [self serviceCallForGlobalMeditation];
//                      [self.tableViewOutlet performSelector:@selector(reloadData) withObject:nil afterDelay:2.0];
                      [self.tableViewOutlet reloadData];
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

-(void)serviceCallForGlobalMeditationUnJoin:(NSInteger) index
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    GlobalMeditationModelClass *obj = [_upcomingMeditations objectAtIndex:index];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_GLOBAL_MEDITATION_UNREGISTRATION" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[Utility userId] forKey:User_Id];
    [dict setObject:obj.topicId forKey:@"topic_id"];
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
                      NSString *success=[responseObject objectForKey:@"success"];
                     
                      [self.view makeToast:@"You have left this meditation."];
                      
                      [self serviceCallForGlobalMeditation];
//                      [self.tableViewOutlet performSelector:@selector(reloadData) withObject:nil afterDelay:2.0];
                      [self.tableViewOutlet reloadData];
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

-(void)serviceCallForLatLong
{
    if (!_upcomingMeditations.count) {
        return;
    }
    GlobalMeditationModelClass *obj = [_upcomingMeditations objectAtIndex:0];
    NSString *topicIdStr;
    
    if (obj == nil)
    {
        topicIdStr = @"";
    }
    else
    {
        topicIdStr = obj.topicId;
    }
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_USER_GET_LAT_LONG" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[NSString stringWithFormat:@"%f",currentCor.latitude] forKey:@"latitude"];
    [dict setObject:[NSString stringWithFormat:@"%f",currentCor.longitude] forKey:@"longitude"];
    [dict setObject:[NSString stringWithFormat:@"4682"] forKey:@"raidus"]; // 4682
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:topicIdStr forKey:@"topic_id"];

    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if ([responseObject isKindOfClass:[NSDictionary class]])
          {
              responseObject = [Utility convertDictionaryIntoUTF8:[responseObject allValues] dictionary:responseObject];
              self.responseDict = responseObject;
          }
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                  NSLog(@"blank Array");
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
                      locationIndex = 0;
                      [self addRegionOnMap:responseObject];
                    
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

#pragma mark-MapView Delegate methods-


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        self.mapViewOutlet.showsUserLocation=YES;
        NSLog(@"%s return nil", __func__);
        return nil;
    }
    else if ([annotation isKindOfClass:[CustomMkAnnotationViewForGlobalMeditation class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"myPin";
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
     
        CGRect frame = annotationView.frame;
        NSLog(@"adding %f %f %f", annotation.coordinate.latitude, annotation.coordinate.longitude, [(CustomMkAnnotationViewForGlobalMeditation *)annotation count]);
        if ([latLongArray count] && locationIndex < latLongArray.count)
        {
            NSDictionary *dict = [latLongArray objectAtIndex:locationIndex];
            
            float highestUserCount = [(CustomMkAnnotationViewForGlobalMeditation *)annotation count];
            
            if (isRegionWise)
            {
                if (highestUserCount <= 10)
                {
                    NSLog(@"%s return annotation 10x10", __func__);
                    frame.size=CGSizeMake(10, 10);
                }
                else
                {
                CGFloat size = ([(CustomMkAnnotationViewForGlobalMeditation *)annotation count])*0.15;
                    NSLog(@"return annotation size %f", size);
                    if (size>30) {
                        size = 30;
                    }
                frame.size = CGSizeMake(size, size);
                }
            }
            else
            {
                NSLog(@"%s return annotation 50x50", __func__);

                frame.size = CGSizeMake(10, 10);
            }
        }
        annotationView.frame = frame;
        annotationView.layer.cornerRadius = annotationView.frame.size.width/2;
        annotationView.canShowCallout = NO;
        [annotationView.layer setShadowColor:[UIColor blackColor].CGColor];
        [annotationView.layer setShadowOpacity:0.5f];
        [annotationView.layer setShadowRadius:5.0f];
        [annotationView.layer setShadowOffset:CGSizeMake(0, 0)];
        
        [annotationView setBackgroundColor:[UIColor greenColor]];
        locationIndex++;
        self.mapViewOutlet.showsUserLocation=YES;
                NSLog(@"%s return annotation", __func__);
        return annotationView;
        
    }
            NSLog(@"%s END return nil", __func__);
    return nil;
}
- (void) mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views)
    {
        if ([[view annotation] isKindOfClass:[MKUserLocation class]])
        {
            [[view superview] bringSubviewToFront:view];
        }
        else
        {
            [[view superview] sendSubviewToBack:view];
        }
    }
}


-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    return;
    for (NSObject *annotation in [mapView annotations])
    {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            NSLog(@"Bring blue location dot to front");
            MKAnnotationView *view = [mapView viewForAnnotation:(MKUserLocation *)annotation];
            [[view superview] bringSubviewToFront:view];
        }
    }
    //centerCoor = [self getCenterCoordinate];
    radius = [self getRadius];


 
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:currentCor.latitude longitude:currentCor.longitude];
    CLLocation *newLoc = [[CLLocation alloc] initWithLatitude:newCenter.latitude longitude:newCenter.longitude];

    CLLocationDistance itemDist = [newLoc distanceFromLocation:currentLoc]/1000;
    
//    if (!flag)
//    {
//       currentZoomLevel=40 - [self getZoomLevel];
//        flag = YES;
//    }
    currentZoomLevel=40 - [self getZoomLevel];

    
//    if (currentZoomLevel >= 16)
//    {
//        currentZoomLevel--;
//    }
//    else if (currentZoomLevel < 16)
//    {
//        currentZoomLevel++;
//    }
    // int x=pow(2, currentZoomLevel/2);
    if (itemDist >=currentZoomLevel * 20)
    {
        [mapView removeAnnotations:mapView.annotations];

        [self serviceCallForLatLong];
        newCenter = [self getCenterCoordinate];
    }
    else if(currentZoomLevel < 16 && currentZoomLevel > 10)
    {
        if (itemDist > currentZoomLevel/2)
        {
            [mapView removeAnnotations:mapView.annotations];

            [self serviceCallForLatLong];
            newCenter = [self getCenterCoordinate];
            
        }
    }
    else if(currentZoomLevel <= 10 && currentZoomLevel >= 5)
    {
        if (itemDist > currentZoomLevel/4)
        {
            [mapView removeAnnotations:mapView.annotations];

            [self serviceCallForLatLong];
            newCenter = [self getCenterCoordinate];
            
        }
    }
    else if(currentZoomLevel < 5)
    {
        [mapView removeAnnotations:mapView.annotations];

        [self serviceCallForLatLong];
        newCenter = [self getCenterCoordinate];
        
    }
//    else
//        newCenter=centerCoor;
}

- (void)addRegionOnMap:(NSDictionary *)response
{
    latLongArray = [[NSMutableArray alloc] init];
    latLongArray=[response objectForKey:@"latlong"];
    if ([[response objectForKey:@"region_wise"] isEqualToString:@"0"])
    {
        isRegionWise = NO;
    }
    else
        isRegionWise = YES;
    
    if(isRegionWise)
    {
        
        if (latLongArray.count >0)
        {
            NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            latLongArray = [NSMutableArray arrayWithArray:[latLongArray sortedArrayUsingDescriptors:sortDescriptors]];
            if (isRegionWise)
            {
                for (int i = 0; i < latLongArray.count; i++)
                {
                    
                    NSDictionary *dict = [latLongArray objectAtIndex:i];
                    NSLog(@"count = %lu",[[dict objectForKey:@"count"] integerValue]);

                    if ([[dict objectForKey:@"count"] integerValue] == 0)
                    {
                        [latLongArray removeObject:dict];
                        i = 0;
                    }
                }
            }
            
            for (NSDictionary *dict in latLongArray)
            {
                CLLocationCoordinate2D center=CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] doubleValue], [[dict objectForKey:@"longitude"] doubleValue]);
                CustomMkAnnotationViewForGlobalMeditation *customAnnotation1=[[CustomMkAnnotationViewForGlobalMeditation alloc]initWithTitle:@"" Location:center];
                customAnnotation1.count = [[dict objectForKey:@"count"] integerValue];
                [self.mapViewOutlet addAnnotation:customAnnotation1];
                self.customAnnotation = customAnnotation1;

            }
        }
    }
    else
    {
        for (NSDictionary *dict in latLongArray)
        {
            CLLocationCoordinate2D center=CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] doubleValue], [[dict objectForKey:@"longitude"] doubleValue]);
            CustomMkAnnotationViewForGlobalMeditation *customAnnotation1=[[CustomMkAnnotationViewForGlobalMeditation alloc]initWithTitle:@"" Location:center];
            customAnnotation1.count = [[dict objectForKey:@"count"] integerValue];

            [self.mapViewOutlet addAnnotation:customAnnotation1];
            self.customAnnotation = customAnnotation1;
        }
    }
    [self.tableViewOutlet reloadData];
}


- (CLLocationDistance)getRadius
{
    //centerCoor = [self getCenterCoordinate];
    // init center location from center coordinate
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:currentCor.latitude longitude:currentCor.longitude];
    
    CLLocationCoordinate2D topCenterCoor = [self getTopCenterCoordinate];
    CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:topCenterCoor.latitude longitude:topCenterCoor.longitude];
    
    radius = [centerLocation distanceFromLocation:topCenterLocation];
    radius = radius/1000.0;
    return radius;
}

- (CLLocationCoordinate2D)getCenterCoordinate
{
    CLLocationCoordinate2D center = [self.mapViewOutlet centerCoordinate];
    return center;
}

- (CLLocationCoordinate2D)getTopCenterCoordinate
{
    // to get coordinate from CGPoint of your map
    CLLocationCoordinate2D topCenterCoor = [self.mapViewOutlet convertPoint:CGPointMake(self.mapViewOutlet.frame.size.width / 2.0f, 0) toCoordinateFromView:self.mapViewOutlet];
    return topCenterCoor;
}
//
//#define MERCATOR_RADIUS 85445659.44705395
//#define MAX_GOOGLE_LEVELS 20
//
//@interface MKMapView (ZoomLevel)
//- (double)getZoomLevel;
//@end
//
//@implementation MKMapView (ZoomLevel)
//
- (double)getZoomLevel
{

  //  MKCoordinateRegion region;
   // CLLocationDegrees longitudeDelta =region.span.longitudeDelta;
    CLLocationDegrees longitudeDelta =1;
    CGFloat mapWidthInPixels = self.mapViewOutlet.bounds.size.width;
    double zoomScale = longitudeDelta * [self getRadius] * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = 20 - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}


- (IBAction)infoBtnActn:(id)sender
{
    [self.tableViewOutlet reloadData];
    self.closeBtn.hidden=NO;
    self.infoWebView.hidden=NO;
    self.btnMenu.hidden=YES;
    self.infoBtn.hidden=YES;
    self.dashboardBtn.hidden = YES;
    self.titleGlobalMeditation.hidden = YES;
    [self serviceCallForInfo];

}
- (IBAction)closeBtnActn:(id)sender
{
    self.btnMenu.hidden=NO;
    self.infoBtn.hidden=NO;
    self.dashboardBtn.hidden =NO;
    self.titleGlobalMeditation.hidden = NO;
    
    self.closeBtn.hidden=YES;
    self.infoWebView.hidden=YES;
}
-(void)serviceCallForInfo
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    [SVProgressHUD show];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"GLOBAL_MEDITATION_INFORMATION" forKey:@"REQUEST_TYPE_SENT"];
    
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
          [SVProgressHUD dismissWithDelay:1.0];
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
