//
//  News&EventsViewController.m
//  Meditation
//
//  Created by IOS-2 on 02/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "News&EventsViewController.h"
#import "NewsTableViewCell.h"
#import "EvemtsTableViewCell.h"
#import "NewsViewController.h"
#import "EventsViewController.h"
#import "NewsModelClass.h"
#import "EventsModelClass.h"
#import "MDLabel.h"

@interface News_EventsViewController ()<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>
{
    NSMutableArray *arrNewsModelObjects;
    NSMutableArray *arrEventsModelObjects;
    BOOL isCallingService;
    BOOL moreNewsAvailable;
    BOOL moreEventsAvailable;
}

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@end

@implementation News_EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view.
    
    arrNewsModelObjects = [NSMutableArray new];
    arrEventsModelObjects = [NSMutableArray new];
    [self serviceGetNews:@"0"];
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    //df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSString *dateString = [df stringFromDate:date];
    
    [self serviceGetEvents:dateString];
}


-(void)serviceGetNews:(NSString *)newsId
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    //----WEB SERVICES---------//
    [SVProgressHUD show];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_GET_NEWS" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:newsId forKey:@"newsId"];


    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if ([responseObject isKindOfClass:[NSDictionary class]])
          {
              responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
          }
          [SVProgressHUD dismiss];
          if (!error)
          {
              isCallingService = NO;
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
                  NSArray *arrNewsList = [responseObject objectForKey:@"news"];
                  if (arrNewsList.count)
                  {
                    for (NSDictionary *dictNewsInfo in arrNewsList )
                  {
                      NewsModelClass *obj = [[NewsModelClass alloc]initWithDictionary:dictNewsInfo];
                      [arrNewsModelObjects addObject:obj];
                  }
                  //[self.newsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                      [self.newsTableView reloadData];
                      moreNewsAvailable = YES;
                  }
                  else
                  {
                  moreNewsAvailable = NO;
                  }
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

-(void) loadNewsWithIndex:(NSIndexPath *) indexPath {
    NewsModelClass *obj = [arrNewsModelObjects objectAtIndex:indexPath.row];
    NewsViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"News"];
    cont.newsTextViewString = obj.newsContent;
    cont.newsTitleString = obj.newsTitle;
    if ([Utility sharedInstance].isDeviceIpad)
    {
        UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:cont];
        self.splitViewController.viewControllers = @[self, navCont];
    }
    else
    {
        [self.navigationController pushViewController:cont animated:YES];
    }
    //[self.newsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.newsTableView reloadData];
}


-(void) loadEventsWithIndex:(NSIndexPath *) indexPath {
    EventsModelClass *obj = [arrEventsModelObjects objectAtIndex:indexPath.row];
    EventsViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"Events"];
    cont.eventTitleString = obj.eventName;
    cont.eventTextViewString = obj.eventDescription;
    cont.bookBtnUrlString = obj.eventJoinUrl;
    cont.startDateString = obj.eventStartsOn;
    cont.endDateString = obj.eventEndsOn;
    if ([Utility sharedInstance].isDeviceIpad)
    {
        UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:cont];
        self.splitViewController.viewControllers = @[self, navCont];
    }
    else
    {
        [self.navigationController pushViewController:cont animated:YES];
    }
    //[self.newsTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [self.newsTableView reloadData];
}

-(void)serviceGetEvents:(NSString *)timeStamp
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    //----WEB SERVICES---------//
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_GET_EVENT" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:timeStamp forKey:@"current_date"];

    [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if ([responseObject isKindOfClass:[NSDictionary class]])
          {
              responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
          }
          [SVProgressHUD dismiss];
          if (!error)
          {
              isCallingService = NO;
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
                  NSArray *arrEventsList = [responseObject objectForKey:@"events"];
                  if (arrEventsList.count)
                  {
                      for (NSDictionary *dictEventsInfo in arrEventsList )
                      {
                          EventsModelClass *obj = [[EventsModelClass alloc]initWithDictionary:dictEventsInfo];
                          [arrEventsModelObjects addObject:obj];
                      }
//                      [self.newsTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                      [self.newsTableView reloadData];
                      moreEventsAvailable = YES;
                  }
                  else
                  {
                      moreEventsAvailable = NO;
                  }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (arrNewsModelObjects.count && arrEventsModelObjects.count) {
        sections = 2;
    }
    else if(arrNewsModelObjects.count || arrEventsModelObjects.count) {
        sections = 1;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (tableView.numberOfSections == 2) {
        if(section == 0) {
            rows =  arrNewsModelObjects.count;
        } else {
            rows = arrEventsModelObjects.count;
        }
    } else if (tableView.numberOfSections == 1){
        if(section == 0) {
            rows = arrNewsModelObjects.count?arrNewsModelObjects.count:arrEventsModelObjects.count;
        }
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.numberOfSections == 2) {
           if (indexPath.section == 0) {
               
               NewsTableViewCell *newsCell=[tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
               NewsModelClass *obj = [arrNewsModelObjects objectAtIndex:indexPath.row];
               newsCell.newsTitle.text = obj.newsTitle;
               newsCell.newsSubTitle.text = obj.newsContent;
        //       [newsCell setSelectionStyle:UITableViewCellSelectionStyleNone];

               return newsCell;
           } else {
                EvemtsTableViewCell *EventsCell=[tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
                EventsModelClass *obj = [arrEventsModelObjects objectAtIndex:indexPath.row];
                EventsCell.eventTitle.text = obj.eventName;
                
                NSDateFormatter *df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date=[df dateFromString:obj.eventStartsOn];
                [df setDateFormat:@"dd/MMM/yyyy"];
                NSString *dateString = [df stringFromDate:date];
                NSString *venueAndDate = [NSString stringWithFormat:@"%@, %@", obj.eventVenue, dateString];
                
                EventsCell.eventSubTitle.text = venueAndDate;
        //        [EventsCell setSelectionStyle:UITableViewCellSelectionStyleNone];

                return EventsCell;
            }
    } else {
        if (arrNewsModelObjects.count) {
            NewsTableViewCell *newsCell=[tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
            NewsModelClass *obj = [arrNewsModelObjects objectAtIndex:indexPath.row];
            newsCell.newsTitle.text = obj.newsTitle;
            newsCell.newsSubTitle.text = obj.newsContent;
            //       [newsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return newsCell;
        } else if (arrEventsModelObjects.count){
            EvemtsTableViewCell *EventsCell=[tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
            EventsModelClass *obj = [arrEventsModelObjects objectAtIndex:indexPath.row];
            EventsCell.eventTitle.text = obj.eventName;
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date=[df dateFromString:obj.eventStartsOn];
            [df setDateFormat:@"dd/MMM/yyyy"];
            NSString *dateString = [df stringFromDate:date];
            NSString *venueAndDate = [NSString stringWithFormat:@"%@, %@", obj.eventVenue, dateString];
            
            EventsCell.eventSubTitle.text = venueAndDate;
            //        [EventsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return EventsCell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.numberOfSections == 2) {
//    if(indexPath.section == 0)
//    {
//        [self loadNewsWithIndex:indexPath];
//    } else {
//        [self loadEventsWithIndex:indexPath];
//    }
//    } else {
//        if (arrNewsModelObjects.count) {
//            [self loadNewsWithIndex:indexPath];
//        } else {
//            [self loadEventsWithIndex:indexPath];
//
//        }
//    }
    
        if(indexPath.section == 0)
        {
            if (arrNewsModelObjects.count) {
            [self loadNewsWithIndex:indexPath];
            }
            else {
                [self loadEventsWithIndex:indexPath];
            }
        } else {
            [self loadEventsWithIndex:indexPath];
        }
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([Utility sharedInstance].isDeviceIpad) ? 60 : 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = ([Utility sharedInstance].isDeviceIpad) ? 60 : 44;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.frame), headerHeight)];
    [bgView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:127.0/255.0 blue:138.0/255.0 alpha:1.0]];
    
    MDLabel *label = [[MDLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame), headerHeight)];
    label.leftPading = 17;
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"Santana" size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? 30.0 : 20.0]];
    
    if (tableView.numberOfSections == 2) {
        if (section == 0) {
            [label setText:@"news"];
        } else {
            [label setText:@"events"];
        }
    } else {
        if (arrNewsModelObjects.count) {
            [label setText:@"news"];
        } else {
            [label setText:@"events"];
        }
    }
    
    [bgView addSubview:label];
    return bgView;
}

#pragma mark- scrollView delegate methods.

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1)
    {
        //news tableView.
        if (moreNewsAvailable)
    {
          float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height)
    {
        //scrolled to the bottom.
        if (!isCallingService)
        {
            //if service is not getting called then only call service.
            isCallingService = YES;
            NewsModelClass *news = [arrNewsModelObjects lastObject];
            if (news)
            {
                [self serviceGetNews:news.newsId];
            }
        }
    }
    }
    return;
    }
    else
    {
        //news tableView.
        if (moreEventsAvailable)
        {
            float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (endScrolling >= scrollView.contentSize.height)
            {
                //scrolled to the bottom.
                if (!isCallingService)
                {
                    //if service is not getting called then only call service.
                    isCallingService = YES;
                    EventsModelClass *event = [arrEventsModelObjects lastObject];
                    if (event)
                    {
                        [self serviceGetEvents:event.eventStartsOn];
                    }
                }
            }
        }
        return;
    }
    
}


- (IBAction)menuBtnActn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
