//
//  NewsViewController.m
//  Meditation
//
//  Created by IOS-2 on 02/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "NewsViewController.h"
#import "SocialShareViewController.h"
#import "Utility.h"
@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden=YES;

    self.newsTitleLbl.text = self.newsTitleString;
    //self.newsTextView.text = self.newsTextViewString;
    self.newsTextView.attributedText = [Utility changeLineSpacing:self.newsTextViewString];
    [self.newsTextView setTextContainerInset:UIEdgeInsetsMake(15, 14, 15, 14)];
    self.newsTextView.textColor=[UIColor colorWithRed:66/255.0 green:60/255.0 blue:79/255.0 alpha:1];

    self.shareBtn.layer.cornerRadius=5.0;
    self.shareBtn.clipsToBounds=YES;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareBtnActn:(id)sender
{
    SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
    cont.navigated = YES;
    cont.isSplit = YES;
    cont.titleLabelString = @"share this news";
    cont.textToShare = self.newsTextView.text ;
    [self.navigationController pushViewController:cont animated:YES];
}

- (IBAction)menuBtnActn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];

}
@end
