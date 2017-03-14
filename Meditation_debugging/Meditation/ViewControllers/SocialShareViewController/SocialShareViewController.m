

//
//  SocialShareViewController.m
//  Meditation
//
//  Created by IOS1-2016 on 16/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "SocialShareViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "SocialShareScene.h"
#import "WebViewController.h"

@interface SocialShareViewController ()<MFMailComposeViewControllerDelegate, SocialShareActionDelegate>
@property(nonatomic, strong)SKView *skView;
@property(nonatomic, strong)SocialShareScene *scene;
@end

@implementation SocialShareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   // [Utility sharedInstance].enterBackground = YES;
    if ([self.textToShare isKindOfClass:[NSNull class]] || self.textToShare == nil)
    {
        self.textToShare=@"";
    }
    if ([self.titleLabelString isKindOfClass:[NSNull class]] || self.titleLabelString == nil)
    {
        self.titleLabelString=@"share this url";
    }
    self.navigationController.navigationBarHidden = YES;
    if (self.navigated)
    {
        self.titleLabel.text=self.titleLabelString;
        self.menuBtn.hidden=YES;
        UIButton *closeBtn;
        if ([Utility sharedInstance].isDeviceIpad)
        {
//            closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 15, 55, 55)];
               closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 15, 55, 55)];
        }
        else
        {
            closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 16, 33, 33)];
//            skView = [[SKView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];

        }
//        if ([Utility sharedInstance].isDeviceIpad)
//        {
//            closeBtn=[[UIButproton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70-320, 15, 55, 55)];
//        }
        [closeBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        [closeBtn addTarget:self action:@selector(closeBtnActn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addShareScene) name:@"addShareScreen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShareScene) name:@"removeShareScene" object:nil];

    [self addShareScene];
}


-(void)viewDidDisappear:(BOOL)animated
{
  //  [Utility sharedInstance].enterBackground = NO;

}
-(void)addShareScene
{
    if (![self.skView isDescendantOfView:self.view])
    {
        if ([Utility sharedInstance].isDeviceIpad)
        {
            if (self.isSplit)
            {
                //            self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width-320, self.view.frame.size.height-100)];
                self.scene = [SocialShareScene nodeWithFileNamed:@"SocialShareSceneIpadSplit"];
                self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
                
            }
            else
            {
                
                self.scene = [SocialShareScene nodeWithFileNamed:@"SocialShareSceneIpad"];
                self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
            }
            
        }
        else
        {
            self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
            self.scene = [SocialShareScene nodeWithFileNamed:@"SocialShareScene"];
        }
        
        [self.skView setBackgroundColor:[UIColor clearColor]];
        [self.skView setAllowsTransparency:YES];
        [self.view addSubview:self.skView];
        
        self.skView.showsFPS = NO;
        self.skView.showsNodeCount = NO;
        self.scene.delegate = self;
        
        self.skView.showsQuadCount = NO;
        // Sprite Kit applies additional optimizations to improve rendering performance /
        self.skView.ignoresSiblingOrder = YES;
        //    SocialShareScene *scene = [SocialShareScene nodeWithFileNamed:@"SocialShareScene"];
        self.scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.skView presentScene:self.scene];
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeBtnActn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuActionButton:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (void)facebookShareAction
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:self.textToShare];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"No Account Configured." message:@"It seems your Facebook account is not set. You can configure it in Settings facebook ." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }

}

- (void)twitterShareAction
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:self.textToShare];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"No Account Configured." message:@"It seems your Twitter account is not set. You can configure it in Settings twitter ." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
}

- (void)showGooglePlusShare
{
    WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
    vc.message = _textToShare;
    [self.navigationController pushViewController:vc animated:YES];
//    NSURL *shareURL = [NSURL URLWithString:@"http://www.rapidsofttechnologies.com"];
//
//    // Constructing the Google+ share URL
//    NSURLComponents* urlComponents = [[NSURLComponents alloc]
//                                      initWithString:@"https://plus.google.com/share"];
//    urlComponents.queryItems = @[[[NSURLQueryItem alloc]
//                                  initWithName:@"url"
//                                  value:[shareURL absoluteString]]];
//    NSURL* url = [urlComponents URL];
//    [[UIApplication sharedApplication] openURL:url];
//    if ([SFSafariViewController class])
//    {
//        // Open the URL in SFSafariViewController (iOS 9+)
//        SFSafariViewController* controller = [[SFSafariViewController alloc]
//                                              initWithURL:url];
//        controller.delegate = self;
//        [self presentViewController:controller animated:YES completion:nil];
//    } else {
//        // Open the URL in the device's browser
//        [[UIApplication sharedApplication] openURL:url];
//    }
}
- (void)emailShareAction
{
    NSString *emailTitle = @"The Pin Prick Meditation";
    NSString *messageBody = self.textToShare;

    if ([MFMailComposeViewController canSendMail])
    {   MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"No Mail Accounts" message:@"Please set up a Mail account in order to send email." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
}

-(void)whatsAppShareAction
{
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",self.textToShare];
    
    NSString *str=[NSString stringWithFormat:@"%@",[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL * whatsappURL = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"Pin Prick Effect would like to open Whatsapp to %@",self.titleLabelString] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     
                                  [[UIApplication sharedApplication] openURL: whatsappURL];
                                     [self removeShareScene];
                                     [Utility sharedInstance].removeShareScene = YES;
                                 }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        
        [myAlert addAction:openAction];
        [myAlert addAction:cancelAction];

        [self presentViewController:myAlert animated:YES completion:nil];
        
    }
    else
    {
        UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"whatsapp not installed" message:@"whatsapp not installed in your Device" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [myAlert addAction:action];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
}

-(void)removeShareScene
{
    [self.scene removeFromParent];
    [self.skView removeFromSuperview];
    self.skView = nil;
}

- (void)actionOnNode:(NSString *)nodeName
{
    if ([nodeName isEqualToString:@"facebook_big"]) {
        [self facebookShareAction];
    }
    else if ([nodeName isEqualToString:@"twitter_big"]) {
        [self twitterShareAction];
    }
    else if ([nodeName isEqualToString:@"linkedin_big"]) {
        [self showGooglePlusShare];
    }
    else if ([nodeName isEqualToString:@"email_big"]) {
        [self emailShareAction];
    }
    else if ([nodeName isEqualToString:@"whatsapp_big"]) {
        [self whatsAppShareAction];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)dashboarBtnActn:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setRootViewController:appDel.dashBoardViewController];
 
}
@end
