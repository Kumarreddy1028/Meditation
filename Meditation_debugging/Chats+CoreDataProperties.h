//
//  Chats+CoreDataProperties.h
//  Meditation
//
//  Created by IOS1-2016 on 23/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chats.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chats (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *messageId;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *topicName;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *topicId;

@end

NS_ASSUME_NONNULL_END
