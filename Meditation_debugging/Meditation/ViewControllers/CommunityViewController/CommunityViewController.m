//
//  CommunityViewController.m
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityTableViewCell.h"
#import "ImmersionCampViewController.h"
#import "communityModelClass.h"
#import "DiscussionAboutSwamijiViewController.h"
#import "SignInViewController.h"
#import "AppDelegate.h"

@interface CommunityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayForBool, *dataArray;
    UIButton *favourite;
}

@end

@implementation CommunityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self serviceDataCalling];
}

-(void)serviceDataCalling
{
    if (![Utility isNetworkAvailable]) {
        [self.view makeToast:@"network connection seems to be offline"];
        return;
    }
    NSMutableDictionary *dic= [[NSMutableDictionary alloc]init];
    [dic setObject:@"SERVICE_USER_COMMUNITY" forKey:@"REQUEST_TYPE_SENT"];
    [dic setObject:[Utility userId] forKey:User_Id];
    [dic setObject:@"2" forKey:@"device_type"];
    [dic setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [SVProgressHUD show];
    NSMutableURLRequest *req= [Utility getRequestWithData:dic];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          [SVProgressHUD dismiss];
          if (!error) {
              NSLog(@"Reply JSON: %@", responseObject);
              
              if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                  NSArray *upcomingEvent=[responseObject objectForKey:@"upcoming_events"];
                  NSArray *discussionTopic =[responseObject objectForKey:@"discussion_topics"];
                  
                  NSMutableArray *events=[[NSMutableArray alloc]init];
                  NSMutableArray *discussions=[[NSMutableArray alloc]init];
                  arrayForBool = [[NSMutableArray alloc]init];
                  dataArray = [[NSMutableArray alloc]init];
                  
                  if (upcomingEvent.count)
                  {
                      for(NSDictionary *dic in upcomingEvent)
                      {
                          communityModelClass *obj=[[communityModelClass alloc]initWithDictionary:dic];
                          [events addObject:obj];
                      }
                      [arrayForBool addObject:[NSNumber numberWithBool:YES]];
                  }
                  
                  if (discussionTopic.count)
                  {
                      for(NSDictionary *dic in discussionTopic)
                      {
                          NSDictionary *dict=[[NSDictionary alloc]initWithDictionary:dic];
                          [discussions addObject:dict];
                          [arrayForBool addObject:[NSNumber numberWithBool:YES]];
                      }
                  }
                  [dataArray addObject:events];
                  [dataArray addObject:discussions];
                  if (arrayForBool.count) {
                      [_communityView reloadData];
                  }
              }
          } else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

#pragma mark-tableView dataSource methods-

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 50;
    }
    else
    {
        return 0;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0)
    {
        communityModelClass *obj = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.labelUpcomingEvents.text=obj.eventName;
        cell.labelDiscussion.text=obj.startOn;
        cell.labelEndOn.text=[NSString stringWithFormat:@"to    %@",obj.endOn];
        [cell.rightImage setImage:[UIImage imageNamed:@""]];
        if (![obj.isRegistered isEqualToString:@"0"]) {
            [cell.rightImage setImage:[UIImage imageNamed:@"right"]];
        }
    }
    else
    {
        NSDictionary *dict = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.labelUpcomingEvents.text = [dict objectForKey:@"discussions_topic"];
        cell.labelDiscussion.text=@"";
        cell.labelEndOn.text=@"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        communityModelClass *obj = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        ImmersionCampViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"immersionCamp"];
        [cont setEvent:obj];
        if ([Utility sharedInstance].isDeviceIpad)
        {
            UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:cont];
            self.splitViewController.viewControllers = @[self, navCont];
        }
        else
        {
        [self.navigationController pushViewController:cont animated:YES];
        }
    }
    else
    {
        BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
        if (loggedIn)
        {
            DiscussionAboutSwamijiViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"discussionAboutSwamiji"];
            NSDictionary *dict = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cont.pageTitle = [dict objectForKey:@"discussions_topic"];
            cont.discussionId = [dict objectForKey:@"discussions_id"];
            if ([Utility sharedInstance].isDeviceIpad)
            {
                UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:cont];
                self.splitViewController.viewControllers = @[self, navCont];
            }
            else
            {
                [self.navigationController pushViewController:cont animated:YES];
            }
        }
        else
        {
            //user is not logged in.
            UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Please sign-in" message:@"You need to be signed in to see the discussions." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"sign-in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                           {
                                               SignInViewController *signInController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                                               [self presentViewController:signInController animated:YES completion:nil];
                                           }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"not now" style:UIAlertActionStyleDefault handler:nil];
            [myAlert addAction:signInAction];
            [myAlert addAction:cancelAction];
            [self presentViewController:myAlert animated:YES completion:nil];
        }
    }
}

#pragma mark-tableView DelegateMethods-

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([Utility sharedInstance].isDeviceIpad) {
        return 60;
    }
    else
        return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //TO ADD A VIEW FOR SECTION HEADER//
    favourite = [[UIButton alloc]init];
    UIView *sectionView;
    UILabel *viewLabel;
    UIView* separatorLineView;
    if ([Utility sharedInstance].isDeviceIpad) {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 15,_communityView.frame.size.width, 30)];
        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, _communityView.frame.size.width, 1)];
        [favourite setFrame:CGRectMake( _communityView.frame.size.width-43,13,33,33)];
    }
    else
    {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5,_communityView.frame.size.width, 20)];
        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, _communityView.frame.size.width, 1)];
        [favourite setFrame:CGRectMake( _communityView.frame.size.width-30,5,20,20)];


    }
    sectionView.tag=section;
    sectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:sectionView];
    
    //TO ADD A LABEL IN SECTION.
    
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor whiteColor];
    if ([Utility sharedInstance].isDeviceIpad) {
        viewLabel.font=[UIFont fontWithName:@"Santana" size:24.0];
    }
    else
        viewLabel.font=[UIFont fontWithName:@"Santana" size:14.0];
    if (section==0)
    {
        viewLabel.text=@"upcoming events";
    }
    else
        viewLabel.text=@"discussions";
   // viewLabel.text=[dataArray objectAtIndex:];
    [sectionView addSubview:viewLabel];
    
    //TO ADD A BUTTON IN SECTION.
    
    favourite.tag=section;
   
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
       [favourite setImage:[UIImage imageNamed:@"collapse"] forState:UIControlStateNormal];
    }
    else
    {
        [favourite setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
    }
    
    [favourite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favourite.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [favourite addTarget:self action:@selector(favourite:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:favourite];
    
    /********** Add a custom Separator with Section view *******************/
    separatorLineView.backgroundColor = [UIColor grayColor];
    [sectionView addSubview:separatorLineView];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    return  sectionView;
    
}

// FAVOURITE BUTTON SELECTOR//
#pragma mark-buttonAction-

-(void)favourite:(UIButton *)button
{
    if ([[dataArray objectAtIndex:button.tag] count] )
    {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:button.tag];
    
    BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    for (int i=0; i<[dataArray count]; i++)
    {
        if (indexPath.section==i)
        {
            if ([favourite isSelected])
            {
                
                [button setImage:[UIImage imageNamed:@"collapse"] forState:UIControlStateNormal];
                [_communityView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];

                [favourite setSelected:NO];
            }
            
            [UIView transitionWithView:self.communityView
                              duration:0.35f
                               options:UIViewAnimationOptionTransitionNone
                            animations:^(void)
             {
                 [self.communityView reloadData];
             }
                            completion:nil];
            
            [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
            
            [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            [_communityView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    }
}

#pragma mark-gestureMethod-

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([[dataArray objectAtIndex:gestureRecognizer.view.tag] count] )
    {
        [_communityView reloadData];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
        
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[dataArray count]; i++)
        {
            if (indexPath.section==i)
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                [_communityView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

#pragma mark-menuBtnAction-
- (IBAction)menuBtnActn:(id)sender
{
    if ([Utility sharedInstance].isDeviceIpad)
    {
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel setRootViewController:appDel.dashBoardViewController];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
