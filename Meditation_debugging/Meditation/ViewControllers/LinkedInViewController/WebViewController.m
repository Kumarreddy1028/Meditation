//
//  WebViewController.m
//  LinkedInShareDemo
//
//  Created by IOS1-2016 on 29/04/16.
//  Copyright © 2016 IOS1-2016. All rights reserved.
//
#define redirect_url @"http://www.rapidsofttechnologies.com"
#define linkedInKey @"75fxhlvhfg1ejf"
#define linkedInSecret @"93FtHbmlriyS1olJ"
#define authorizationEndPoint @"https://www.linkedin.com/uas/oauth2/authorization"
#define accessTokenEndPoint @"https://www.linkedin.com/uas/oauth2/accessToken"

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

{
    NSString *encodedRdirectURL;
}


- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView.delegate = self;
    encodedRdirectURL = [redirect_url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.alphanumericCharacterSet];
    [self startAuthorisation];
}

-(void)startAuthorisation
{
    // Specify the response type which should always be "code".
    NSString *responseType = @"code";
    // Create a random string
    NSString *state = @"linkedinRoohul";
    // Set preferred scope.
    NSString *scope = @"w_share";
    // Create the authorization URL string.
    NSString *authorizationURL = [NSString stringWithFormat:@"%@?response_type=%@&client_id=%@&redirect_uri=%@&state=%@&scope=%@",authorizationEndPoint,responseType,linkedInKey,encodedRdirectURL,state,scope];

    NSLog(@"%@",authorizationURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authorizationURL]];
    [_webView loadRequest:request];
}

#pragma mark- WebView Delegate.

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    //here we will catch the response of the server which will redirect to our redirect url. Hence we firsrt check for the host(which is our redirect url) then only extract the code.
    if ([url.host isEqualToString:@"www.rapidsofttechnologies.com"])
    {
        if ([url.absoluteString rangeOfString:@"code"].length)
        {
            
//response containing the authorisation code looks somehow like below.
        //our redirect_url?<strong>code=AQSetQ252oOM237XeXvUreC1tgnjR-VC1djehRxEUbyZ-sS11vYe0r0JyRbe9PGois7Xf42g91cnUOE5mAEKU1jpjogEUNynRswyjg2I3JG_pffOClk</strong>&state=linkedin1450703646
            
   //......obtaining the code from the response......//
            NSArray *urlParts = [url.absoluteString componentsSeparatedByString:@"?"];
            NSString *codePart = [urlParts objectAtIndex:1];
            NSArray *codeParts = [codePart componentsSeparatedByString:@"="];
            NSString *code = [codeParts objectAtIndex:1];
            [self requestforAccessToken:code];
        }
    }
    return YES;
}

- (void)requestforAccessToken:(NSString *)authorisationCode
{
    NSString *grantType = @"authorization_code";
    NSString *postParameter = [NSString stringWithFormat:@"grant_type=%@&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",grantType,authorisationCode,encodedRdirectURL,linkedInKey,linkedInSecret];
    NSData *postdata = [postParameter dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:accessTokenEndPoint]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = postdata;
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              NSString *accessToken = [responseObject objectForKey:@"access_token"];
              [self shareMessage:accessToken];
          }
          
      }] resume];
}

-(void)shareMessage:(NSString *)accessToken
{
    NSDictionary *contentDict = @{@"title":@"Black Lotus Effect",
                                        @"description":_message,
                                  @"submitted-url":redirect_url
                                        };
    NSDictionary *visibilityDict = @{@"code":@"anyone"};
    NSDictionary *messageDict = @{@"content":contentDict,
                                  @"visibility":visibilityDict
                                  };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDict options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *linkedInShareUrl = @"https://api.linkedin.com/v1/people/~/shares?format=json";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:linkedInShareUrl]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authorisationHeader = [NSString stringWithFormat:@"Bearer %@",accessToken];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    [request setValue:authorisationHeader forHTTPHeaderField:@"Authorization"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          if (!error)
          {
              NSString *updateUrl = [responseObject objectForKey:@"updateUrl"];
              NSLog(@"updateKey-%@",[responseObject objectForKey:@"updateKey"]);
              NSLog(@"updateUrl-%@",updateUrl);
              UIAlertController * alert=   [UIAlertController
                                            alertControllerWithTitle:@"Post Successful"
                                            message:@"Would you like to be redirected to your profile to see the post"
                                            preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"no" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                  [self.navigationController popViewControllerAnimated:NO];
              }];
              UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
              {
                  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:updateUrl]];
                  [_webView loadRequest:request];
              }];
              [alert addAction:yesAction];
              [alert addAction:noAction];
              [self presentViewController:alert animated:YES completion:nil];
          }
      }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
