//
//  EventsViewController.m
//  Meditation
//
//  Created by IOS-2 on 02/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "EventsViewController.h"
#import "SocialShareViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.shareBtn.layer.cornerRadius=5.0;
    self.shareBtn.clipsToBounds=YES;
    self.bookBtn.layer.cornerRadius=5.0;
    self.bookBtn.clipsToBounds=YES;
    
    self.eventTitleLbl.text = self.eventTitleString;
    
    self.eventsTextView.attributedText=[Utility changeLineSpacing:self.eventTextViewString];
    [self.eventsTextView setTextContainerInset:UIEdgeInsetsMake(15, 14, 15, 14)];

    self.eventsTextView.textColor=[UIColor colorWithRed:66/255.0 green:60/255.0 blue:79/255.0 alpha:1];

    self.startDateString=[self changedateFormat:self.startDateString];
    self.endDateString=[self changedateFormat:self.endDateString];
    NSString *first= [self.startDateString substringToIndex:6];
    NSString *second= [self.endDateString substringToIndex:6];
    if ([first isEqualToString:second])
    {
        NSString *finalDateString=[NSString stringWithFormat:@"%@ %@ - %@",first,[self.startDateString substringFromIndex:7],[self.endDateString substringFromIndex:7]];
        self.dateLabel.text=finalDateString;

    }
    else
    {
          NSString *finalDateString=[NSString stringWithFormat:@"%@ %@ - %@",first,[self.startDateString substringFromIndex:7],self.endDateString];
        
        self.dateLabel.text=finalDateString;
    }
   
    


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)changedateFormat:(NSString*)str
{
    NSString *inDateStr = str;
    NSString *s = @"yyyy/MM/dd HH:mm:ss";
    
    NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
    outDateFormatter.dateFormat = s;
    outDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *outDate = [outDateFormatter dateFromString:inDateStr];
    [outDateFormatter setDateFormat:@"MMM dd @ hh:mma"];
    outDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    NSString *stringDate = [outDateFormatter stringFromDate:outDate];
    
    stringDate=[[stringDate stringByReplacingOccurrencesOfString:@"AM" withString:@"am"]stringByReplacingOccurrencesOfString:@"PM" withString:@"pm"];
    return stringDate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bookBtnActn:(id)sender
{
    
   
    NSURL *URL = [NSURL URLWithString:self.bookBtnUrlString];
    if ([[UIApplication sharedApplication] canOpenURL:URL])
    {
        [[UIApplication sharedApplication] openURL: URL];
    }
}

- (IBAction)shareBtnActn:(id)sender
{
    SocialShareViewController *cont=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
    cont.navigated = YES;
    cont.isSplit = YES;
    cont.titleLabelString = @"share this event";
    cont.textToShare = self.eventsTextView.text ;
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
