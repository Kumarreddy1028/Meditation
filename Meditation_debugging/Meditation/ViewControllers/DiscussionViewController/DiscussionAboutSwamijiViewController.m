//
//  DiscussionAboutSwamijiViewController.m
//  Meditation
//
//  Created by IOS1-2016 on 12/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "DiscussionAboutSwamijiViewController.h"
#import <CoreData/CoreData.h>
#import "ServerMessageTableViewCell.h"
#import "OwnMessageTableViewCell.h"
#import "DiscussionAboutSwamijiModel.h"
#import "CommunityViewController.h"
#import "AppDelegate.h"
#import "Chats.h"
#import "MeditatorsViewController.h"

@interface DiscussionAboutSwamijiViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    NSMutableArray *sortedArrayChats;
    BOOL isCallingService;
}

@end
@implementation DiscussionAboutSwamijiViewController

#pragma mark- view life cycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.btnDiscussion setTitle:self.pageTitle forState:UIControlStateNormal];
    if ([Utility sharedInstance].isDeviceIpad)
    {
        [self.backBtn setHidden:YES];
    }
    self.txtMessage.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    //automatic dimension
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    sortedArrayChats = [[NSMutableArray alloc] init];
    [self firstTimeFetch];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recievePushMessage:)name:@"PushMessageRecievedNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setFocusToLastRow];
}


-(void)recievePushMessage:(NSNotification *)notification
{
    if ([sortedArrayChats count]) {
        [self fetchMessagesForTopicId:self.discussionId messagesShouldBeHigherThanMessageId:[notification.userInfo objectForKey:@"messageId"]];
    }
}

-(void)setFocusToLastRow
{
    NSInteger lastRow = sortedArrayChats.count-1;
    if (lastRow > 0)
    {
        NSIndexPath *lastRowIndexPath =[NSIndexPath indexPathForRow:lastRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastRowIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}

-(void)setFocusToRow:(int)row
{
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}


-(void)firstTimeFetch
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [app managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Chats"];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicId = %@", self.discussionId];
    NSSortDescriptor *sortByMessageId = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByMessageId];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:50];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *fetchedArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    sortedArrayChats = [self reverseArray:fetchedArray];
    if (sortedArrayChats.count)
    {
        //if some messages are fetched.
        if (fetchedArray.count < 50)
        {
            //if fetched messages are < 50 then I have no more messages for load more so load previous service will be called with chatId = the lowest messageId I have.
            Chats *chat = [sortedArrayChats firstObject];
            [self callServiceLoadPreviousChatWithMessageId:chat.messageId];
            self.btnLoadMore.hidden = YES;
            self.tableView.frame = CGRectMake( self.tableView.frame.origin.x, self.tableView.frame.origin.x - 33, self.tableView.frame.size.width, self.tableView.frame.size.height + 33);
        }
        [self.tableView reloadData];
        [self setFocusToLastRow];
    }
    else
    {
        self.btnLoadMore.hidden = YES;
        [self callServiceGetChat:[NSNumber numberWithInt:0]];
    }
}

-(NSMutableArray *)reverseArray:(NSArray *)array
{
    NSMutableArray * reverseArray = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (id element in [array reverseObjectEnumerator]) {
        [reverseArray addObject:element];
    }
    return reverseArray;
}

- (IBAction)backActionButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)discussionActionButton:(id)sender
{
    MeditatorsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"meditators"];
    controller.discussionId = self.discussionId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark- tableView delegate and datasource methods.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sortedArrayChats.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Chats *chat = [sortedArrayChats objectAtIndex:indexPath.row];
    UITableViewCell *cellForReturn;
    NSString *userID = chat.userId;
    NSString *timestamp = [self changeDateFormat:chat.time];
    NSString *userName = chat.name;
    if ([userID  isEqual: [Utility userId]])
    {
        static NSString *CellIdentifier = @"OwnCell";
        OwnMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            cell = [[OwnMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.lblId.text = [userName stringByAppendingString:[NSString stringWithFormat:@"  %@",timestamp]];
        cell.lblMessage.text = chat.message;
        cellForReturn = cell;
    }
    else
    {
        static NSString *CellIdentifier = @"ServerCell";
        ServerMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            cell = [[ServerMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.lblId.text = [userName stringByAppendingString:[NSString stringWithFormat:@"  %@",timestamp]];
        cell.lblMessage.text = chat.message;
        cellForReturn = cell;
    }
    cellForReturn.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellForReturn;
}


-(NSString *)changeDateFormat:(NSString *)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"dd-MM-yy hh:mm a"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    NSLog(@"%@", stringDate);

    return stringDate;
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //dismissing keyboard on tapping anywhere on the tableview since we have disabled the cell selection.
//    [self.txtMessage resignFirstResponder];
//}

#pragma mark- textfield delegate methods.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![Utility isEmpty:textField.text])
    {
        NSDictionary *userInfoDictionary = @{@"REQUEST_TYPE_SENT":@"SERVICE_USER_POST_CHAT",
                                             @"user_id":[Utility userId],
                                             @"discussions_id":self.discussionId,
                                             @"content":textField.text,
                                             @"device_type":@"2",
                                             @"device_token":[[Utility sharedInstance] getDeviceToken],
                                             };
        
        [self callServicePostChatWithInfo:userInfoDictionary];
    }
    return YES;
}

#pragma mark- scrollView delegate methods.

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height)
    {
        if (!isCallingService)
        {
            isCallingService = YES;
            Chats *chat = [sortedArrayChats lastObject];
            if (chat) {
                [self callServiceGetChat:chat.messageId];
            }
        }
    }
}

#pragma  mark- Service call.


-(void)callServicePostChatWithInfo:(NSDictionary *)dict
{
    if ([Utility isNetworkAvailable])
    {
        [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              [SVProgressHUD dismiss];
              if (!error) {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
                  {
                      NSString *error_code=[responseObject objectForKey:@"error_code"];
                      NSString *error_desc=[responseObject objectForKey:@"error_desc"];
                      UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:error_code message:error_desc preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      [myAlert addAction:action];
                      [self presentViewController:myAlert animated:YES completion:nil];
                  }
                  else
                  {//successfully posted.
                      NSMutableArray *chats = [responseObject objectForKey:@"chat_list"];
                      if (chats.count)
                      {
                          [self saveMessageToCoredata:chats AndFetchDirection:fetchDirectionDownward];
                          self.txtMessage.text = @"";
                      }
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
                  
              }
          }] resume];
    }
    else
    {
        [self.view makeToast:@"Network connection seems to be offline"];
    }
}

-(void)callServiceGetChat:(NSNumber *)messageId
{
    if ([Utility isNetworkAvailable])
    {
        NSDictionary *dict = @{@"REQUEST_TYPE_SENT":@"SERVICE_USER_GET_CHAT",
                               @"user_id":[Utility userId],
                               @"discussions_id":self.discussionId,
                               @"chat_id":messageId,
                               @"device_type":@"2",
                               @"device_token":[[Utility sharedInstance] getDeviceToken]};

        [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              [SVProgressHUD dismiss];
              isCallingService = NO;
              if (!error) {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
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
                      //successfully got chats.
                      NSArray *chatArray = [responseObject objectForKey:@"chat_list"];
                      if ([chatArray count])
                      {
                          [self saveMessageToCoredata:chatArray AndFetchDirection:fetchDirectionDownward];
                      }
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
                  
              }
          }] resume];
    }
    else
    {
        [self.view makeToast:@"Network connection seems to be offline"];
    }
}

-(void)callServiceLoadPreviousChatWithMessageId:(NSNumber *)messageId
{
    if ([Utility isNetworkAvailable])
    {
        NSDictionary *dict = @{@"REQUEST_TYPE_SENT":@"SERVICE_LOAD_PREVIOUS_CHAT",
                               @"user_id":[Utility userId],
                               @"discussions_id":self.discussionId,
                               @"chat_id":messageId,
                               @"device_type":@"2",
                               @"device_token":[[Utility sharedInstance] getDeviceToken]};
        
        [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dict];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              [SVProgressHUD dismiss];
              if (!error) {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
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
                      //successfully got chats.
                      NSArray *chatArray = [responseObject objectForKey:@"chat_list"];
                      if ([chatArray count])
                      {
                          [self saveMessageToCoredata:chatArray AndFetchDirection:fetchDirectionUpward];
                          //if the loadmore button was hidden due to    less messages in the first time fetch then unhide it.
                          if (chatArray.count == 50)
                          {
                              if (self.btnLoadMore.isHidden == YES)
                              {
                                  self.btnLoadMore.hidden = NO;
                              }
                          }
                      }
                      else
                      {
                          self.btnLoadMore.hidden = YES;
                          self.tableView.frame = CGRectMake( self.tableView.frame.origin.x, self.tableView.frame.origin.x - 33, self.tableView.frame.size.width, self.tableView.frame.size.height + 33);
                         // [self.view makeToast:@"No more messages available."];
                      }
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
                  
              }
          }] resume];
    }
    else
    {
        [self.view makeToast:@"Network connection seems to be offline"];
    }

}
#pragma mark- coreData handling method.
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)saveMessageToCoredata:(NSArray *)messages AndFetchDirection:(fetchDirection)fetchDirection
{
    if ([messages count] == 0)
    {
        return;
    }
    NSManagedObjectContext *context = nil;
    for(NSDictionary *messageDict in messages)
    {
        //obtaining the messageId as an NSNumber object.
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = kCFNumberFormatterNoStyle;
        NSNumber *myNumber = [f numberFromString:[messageDict objectForKey:@"chat_id"]];
        
        //fetching the message with current messageId.

        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *managedObjectContext = [app managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Chats"];
        [fetchRequest setReturnsObjectsAsFaults:NO];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageId = %@ AND topicId = %@", myNumber, self.discussionId];
        [fetchRequest setPredicate:predicate];
        NSArray *fetchedArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        if (!fetchedArray.count)
        {
            //if no message is there with current messageId then count of fetchedArray will be zero. And the message will be saved.
        context = [self managedObjectContext];
        // Create a new managed object
        NSManagedObject *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Chats" inManagedObjectContext:context];
        [newMessage setValue:[messageDict objectForKey:@"chats"] forKey:@"message"];
        [newMessage setValue:myNumber forKey:@"messageId"];
        [newMessage setValue:[messageDict objectForKey:@"name"] forKey:@"name"];
        [newMessage setValue:[messageDict objectForKey:@"posted_on"] forKey:@"time"];
        [newMessage setValue:[messageDict objectForKey:@"topic_name"] forKey:@"topicName"];
        [newMessage setValue:[messageDict objectForKey:@"user_id"] forKey:@"userId"];
        [newMessage setValue:_discussionId forKey:@"topicId"];
        }
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    NSArray *messageIds = [messages valueForKey:@"chat_id"];
    NSNumber *lowestMessageId=[messageIds valueForKeyPath:@"@min.intValue"];
    NSNumber *highestMessageId=[messageIds valueForKeyPath:@"@max.intValue"];
    switch (fetchDirection)
    {
        case fetchDirectionUpward:
            [self fetchMessagesForTopicId:_discussionId messagesShouldBeLowerThanMessageId:highestMessageId];
            break;
        case fetchDirectionDownward:
            [self fetchMessagesForTopicId:_discussionId messagesShouldBeHigherThanMessageId:lowestMessageId];
            break;
        default:
            break;
    }
}

-(void)fetchMessagesForTopicId:(NSString *)topicId messagesShouldBeHigherThanMessageId:(NSNumber *)messageId
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [app managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Chats"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicId = %@ AND (messageId >= %@)", topicId, messageId];
    NSSortDescriptor *sortByMessageId = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByMessageId];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *fetchedArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [sortedArrayChats addObjectsFromArray:fetchedArray];
    [self.tableView reloadData];
    [self setFocusToLastRow];
    
}

-(void)fetchMessagesForTopicId:(NSString *)topicId messagesShouldBeLowerThanMessageId:(NSNumber *)messageId
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [app managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Chats"];
    [fetchRequest setReturnsObjectsAsFaults:NO];
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topicId = %@ AND (messageId < %@)", topicId, messageId];
    NSSortDescriptor *sortByMessageId = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByMessageId];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:50];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSArray *fetchedArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    sortedArrayChats = [[fetchedArray arrayByAddingObjectsFromArray:sortedArrayChats] mutableCopy];
    if (sortedArrayChats.count)
    {
        //if some messages are fetched.
        if (fetchedArray.count < 50)
        {
            //if fetched messages are < 50 then I have no more messages for load more so load previous service will be called with chatId = the lowest messageId I have.
            Chats *chat = [sortedArrayChats firstObject];
            [self callServiceLoadPreviousChatWithMessageId:chat.messageId];
        }
        [self.tableView reloadData];
        if (fetchedArray.count )
        {
            [self setFocusToRow:fetchedArray.count - 1];
        }
    }
    else
        [self callServiceGetChat:[NSNumber numberWithInt:0]];

}

#pragma mark--------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tapGestureRecogniserAction:(id)sender
{
    [self.txtMessage resignFirstResponder];
}
- (IBAction)loadMoreActionButton:(id)sender
{
     Chats *chat = [sortedArrayChats firstObject];
    [self fetchMessagesForTopicId:self.discussionId messagesShouldBeLowerThanMessageId:chat.messageId];
}
@end
