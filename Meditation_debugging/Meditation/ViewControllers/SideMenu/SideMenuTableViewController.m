//
//  SideMenuTableViewController.m
//  Meditation
//
//  Created by IOS1-2016 on 08/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "AboutPPEViewController.h"
#import "SettingsViewController.h"
#import "AlreadySignedInViewController.h"
#import "SocialShareViewController.h"
#import "SignInViewController.h"
#import "UIImageView+WebCache.h"

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUserNameAndImage];
    [self registerForNotifications];
}

- (void)setUserNameAndImage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults valueForKey:@"userName"];
    NSString *imageUrl = [defaults valueForKey:@"profileImageUrl"];
    
    if ([name isEqualToString:@""] || name == nil)
        self.lblProfileName.text = @"profile";
    else
        self.lblProfileName.text = name;
    if (imageUrl == nil || [imageUrl isEqualToString:@""])
        self.profileImage.image = [UIImage imageNamed:@"profile"];
    else
        [self.profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"profile"]];
    
    self.profileImage.layer.cornerRadius = (self.profileImage.frame.size.width/2);
    self.profileImage.layer.masksToBounds = YES;
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserName:)name:@"UpdateUserNameNotification" object:nil];
}

-(void)updateUserName:(NSNotification *)notification
{
    [self setUserNameAndImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView setAnimationDuration:0];
    switch (indexPath.row) {
        case 1:
        {
            BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
            if (loggedIn)
                    {
                        AlreadySignedInViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AlreadySignedIn"];
                        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [appDel setRootViewController:controller];
                    }
                    else
                    {
                        SignInViewController *signInController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
                        [self presentViewController:signInController animated:YES completion:nil];
                    }
        }
            break;
        case 2:
        {
            AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDel setRootViewController:appDel.dashBoardViewController];
        }
            
            break;
        case 3:
        {
            AboutPPEViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutPPE"];
            AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDel setRootViewController:controller];
            
        }
            break;
        case 4:
        {
            SettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
            AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDel setRootViewController:controller];
        }
            
            break;
        case 5:
        {
  
            NSURL *buyUrl = [NSURL URLWithString:@"http://omswami.com"];
            
            if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
            {
                [[UIApplication sharedApplication] openURL: buyUrl];
            }
        }
            
            break;
        case 6:
        {
            NSURL *buyUrl = [NSURL URLWithString:@"https:youtube.com/omswamitv"];
            
            if ([[UIApplication sharedApplication] canOpenURL: buyUrl])
            {
                [[UIApplication sharedApplication] openURL: buyUrl];
            }
        }
            
            break;
        case 7:
        {
            SocialShareViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
            AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDel setRootViewController:controller];
            
        }
            
            break;
        case 8:
        {
            AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDel setRootViewController:appDel.dashBoardViewController];
            [appDel.dashBoardViewController setNoAnimation:YES];
            [appDel.dashBoardViewController actionOnNode:@"global_meditation"];
        }
            
            break;

            
        default:
            break;
    }
}

@end
