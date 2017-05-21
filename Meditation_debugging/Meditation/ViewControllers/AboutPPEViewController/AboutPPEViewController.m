//
//  AboutPPEViewController.m
//  Meditation
//
//  Created by IOS1-2016 on 03/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "AboutPPEViewController.h"

@interface AboutPPEViewController ()<UIScrollViewDelegate>
@end

@implementation AboutPPEViewController

int textViewInitialTopConstraint;
CGFloat d1;//its the distance that topConstraint will cover.
CGFloat d2;//its the distance that bottomConstraint will cover.

#pragma mark-viewLifecycle.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self serviceCallForInfo];
    [self.textView setTextContainerInset:UIEdgeInsetsMake(15, 10, 10, 10)];
    CGFloat fontSize;
    if ([Utility sharedInstance].isDeviceIpad) {
        fontSize = 20.0;
    }
    else
        fontSize = 17.0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    paragraphStyle.paragraphSpacing = 10.0f;

    NSString *string = self.textView.text;
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];
    d1 = 50 + _textViewTopConstraint.constant;
    d2 = 20;
    textViewInitialTopConstraint = _textViewTopConstraint.constant;
}

-(void)viewDidAppear:(BOOL)animated
{
    [_textView setContentOffset: CGPointMake(0,0) animated:NO];
}

- (IBAction)menuActionButton:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    
}

#pragma mark - UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollableContentSize = _textView.contentSize.height - _textView.frame.size.height;
    CGFloat d1PositionMultiplier = d1 / (scrollableContentSize * 0.9);
    CGFloat d2PositionMultiplier = d2 / (scrollableContentSize * 0.1);
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= ( scrollableContentSize * 0.9))
    {
        CGFloat distance = scrollView.contentOffset.y * d1PositionMultiplier;
        _textViewTopConstraint.constant = textViewInitialTopConstraint - distance;
        _textViewBottomConstraint.constant = 0;
        _blurView.alpha = ((textViewInitialTopConstraint - _textViewTopConstraint.constant) * 0.005);
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    else
    {
        CGFloat distance = (offset - (0.9 * scrollableContentSize)) * d2PositionMultiplier;
        _textViewBottomConstraint.constant = distance;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dashboardBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];

}
-(void)serviceCallForInfo
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    
    [SVProgressHUD show];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"ABOUT_PPE" forKey:@"REQUEST_TYPE_SENT"];
    
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      { if ([responseObject isKindOfClass:[NSDictionary class]])
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
                      NSString *infoStr = [responseObject objectForKey:@"info"];
                      if ([infoStr isKindOfClass:[NSNull class]] || infoStr == nil)
                      {
                          infoStr =@"";
                      }

//                      self.textView.text = infoStr;
//                      CGFloat fontSize;
//                      if ([Utility sharedInstance].isDeviceIpad) {
//                          [self.textView setFont:[UIFont systemFontOfSize:20]];
//                      }
//                      else
//                          [self.textView setFont:[UIFont systemFontOfSize:17]];
//                 
//                      self.textView.attributedText=[Utility changeLineSpacing:infoStr];
                      NSURL *url = [NSURL URLWithString:[responseObject objectForKey:@"info_url"]];
                      [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
                      self.webView.scrollView.bounces = NO;

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
