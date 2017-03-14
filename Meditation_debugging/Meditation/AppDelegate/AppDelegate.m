
//  AppDelegate.m
//  Meditation
//
//  Created by IOS-01 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "AppDelegate.h"
#import "SideMenuTableViewController.h"

@interface AppDelegate ()
{
    NSTimer *myTimer;
    NSString *currentDate;
    NSDateFormatter *df;
    UINavigationController *navigation;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [Utility sharedInstance].isFirstTimeShowDashboardAnimation = YES;
    NSString *storyBoard;
    if ([Utility sharedInstance].isDeviceIpad)
        storyBoard = @"IpadStoryboard";
    else
        storyBoard = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoard bundle:[NSBundle mainBundle]];

    self.socialShareViewController = [storyboard instantiateViewControllerWithIdentifier:@"SocialShare"];
//     Override point for customization after application launch.
    [application setStatusBarHidden:YES];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        [Utility sharedInstance].isDeviceIpad = YES;
    else
        [Utility sharedInstance].isDeviceIpad = NO;

    [self presentHomeScreen];
    [self askUserForPushNotification:application];
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    [[Utility sharedInstance] getCurrentLocationAndRegisterDeviceToken];

    return YES;
    
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.restrictRotation)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (void)presentHomeScreen
{
    NSString *storyBoard;
    if ([Utility sharedInstance].isDeviceIpad)
        storyBoard = @"IpadStoryboard";
    else
        storyBoard = @"Main";

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoard bundle:[NSBundle mainBundle]];
    self.dashBoardViewController = [storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];
    [self setRootViewController:self.dashBoardViewController];

}

- (void)setRootViewController:(UIViewController *)viewController
{
    NSString *storyBoard;
    if ([Utility sharedInstance].isDeviceIpad)
        storyBoard = @"IpadStoryboard";
    else
        storyBoard = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoard bundle:[NSBundle mainBundle]];
    navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    SideMenuTableViewController *sideMenuController = [storyboard instantiateViewControllerWithIdentifier:@"SideMenu"];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:navigation leftMenuViewController:sideMenuController rightMenuViewController:nil];
    self.window.rootViewController = container;
    container.panMode = MFSideMenuPanModeNone;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    
    [Utility sharedInstance].enterBackground = YES;
    [Utility sharedInstance].removeShareScene = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShareScene" object:nil];
        
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn)
    {
        [self serviceCallForDeviceTokenUpdate];
    }
    
    df=[[NSDateFormatter alloc]init];

    [self serviceCallForOnlineUsers:[self currentDate]:[Utility uId]];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    myTimer=[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(userUpdate) userInfo:nil repeats:YES];
    if ([Utility sharedInstance].removeShareScene == YES || [Utility sharedInstance].enterBackground == YES)
    {
        [Utility sharedInstance].removeShareScene = NO;
        [Utility sharedInstance].enterBackground = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addShareScreen" object:nil];

    }
    BOOL cancelNotification = [[NSUserDefaults standardUserDefaults] boolForKey:@"cancelNotification"];
    if (!cancelNotification)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"cancelNotification"];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

-(NSString*)currentDate
{
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    currentDate = [df stringFromDate:[NSDate date]];
    return currentDate;
}

-(void)userUpdate
{
    [self serviceCallForOnlineUsers:[self currentDate]:[Utility uId]];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
   }

#pragma  mark- method for google and facebook Signin integration

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"myapp"])
    {
        NSDictionary *userInfo = [self parametersDictionaryFromQueryString:[url query]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"twitterTokenVerifier" object:nil userInfo:userInfo];
        return YES;
    }
    return (
            [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation]
            ||
            [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                                 sourceApplication:sourceApplication
                                                        annotation:annotation
             ]
            );
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

//======================================================
#pragma mark - PushNotification Handle Method
//======================================================
- (void)askUserForPushNotification:(UIApplication *)application
{
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings * notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[Utility sharedInstance] setDeviceToken:token];
    BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
    if (loggedIn)
    {
        [[Utility sharedInstance] getCurrentLocationAndRegisterDeviceToken];
        [self serviceCallForDeviceTokenUpdate];
    }
    NSLog(@"DeviceToken : %@", token);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *messageDetails = [userInfo valueForKey:@"aps"];
    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"" message:[messageDetails objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [myAlert addAction:action];
  
     [[navigation topViewController] presentViewController:myAlert animated:YES completion:nil];

//    [self saveMessageToCoredata:[messageDetails objectForKey:@"chat_list"]];
    NSLog(@"Push notification received \n%@",userInfo);
}

-(void)saveMessageToCoredata:(NSDictionary *)messageDict
{
    NSManagedObjectContext *context = nil;
    context = [self managedObjectContext];
    // Create a new managed object
    NSManagedObject *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Chats" inManagedObjectContext:context];
    
    [newMessage setValue:[messageDict objectForKey:@"chats"] forKey:@"message"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = kCFNumberFormatterNoStyle;
    NSNumber *myNumber = [f numberFromString:[messageDict objectForKey:@"chat_id"]];
    [newMessage setValue:myNumber forKey:@"messageId"];
    [newMessage setValue:[messageDict objectForKey:@"name"] forKey:@"name"];
    [newMessage setValue:[messageDict objectForKey:@"posted_on"] forKey:@"time"];
    [newMessage setValue:[messageDict objectForKey:@"topic_name"] forKey:@"topicName"];
    [newMessage setValue:[messageDict objectForKey:@"posted_by"] forKey:@"userId"];
    [newMessage setValue:[messageDict objectForKey:@"topic_id"] forKey:@"topicId"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMessageRecievedNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:myNumber forKey:@"messageId"]];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.rapidid.CoreDataSample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Data_Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Data_Model.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark- localNotification delegate.

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"Notification"    message:notification.alertBody
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [notificationAlert show];
    
    // NSLog(@"didReceiveLocalNotification");
}

 -(void)serviceCallForOnlineUsers:(NSString *)date :(NSString *)uid
{
//    if (![Utility isNetworkAvailable])
//    {
//        return;
//    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_UPDATE_USERS_COUNT" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:date forKey:@"time"];
    [dict setObject:uid forKey:@"user_id"];
    
    
    
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
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
                      NSString *userId=[responseObject objectForKey:@"id"];
                      NSString *users = [responseObject objectForKey:@"user_count"];
                      
                      BOOL loggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIn"];
                      
                      if (!loggedIn)
                      {
                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                          [defaults setObject:userId forKey:@"u_id"];
                          [defaults synchronize];
                      }
                      
//                      [[Utility sharedInstance] setOnlineUsers:users];
//                      
//                      [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOnlineUsersCount" object:nil];
                   
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}

-(void)serviceCallForDeviceTokenUpdate
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_UPDATE_DEVICETOKEN" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[Utility userId] forKey:@"user_id"];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
        responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];
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
