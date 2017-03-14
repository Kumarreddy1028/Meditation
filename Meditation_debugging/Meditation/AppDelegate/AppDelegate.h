//
//  AppDelegate.h
//  Meditation
//
//  Created by IOS-01 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DashboardViewController.h"
#import "SocialShareViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DashboardViewController *dashBoardViewController;
@property (strong, nonatomic) SocialShareViewController *socialShareViewController;

@property () BOOL restrictRotation;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)managedObjectContext;
- (void)setRootViewController:(UIViewController *)viewController;
- (void)presentHomeScreen;
-(void)userUpdate;

@end

