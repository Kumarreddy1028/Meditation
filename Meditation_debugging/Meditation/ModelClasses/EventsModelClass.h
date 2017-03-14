//
//  EventsModelClass.h
//  Meditation
//
//  Created by IOS1-2016 on 06/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsModelClass : NSObject

@property(nonatomic,strong) NSString *eventName;
@property(nonatomic,strong) NSString *eventVenue;
@property(nonatomic,strong) NSString *eventDescription;
@property(nonatomic,strong) NSString *eventStartsOn;
@property(nonatomic,strong) NSString *eventEndsOn;
@property(nonatomic,strong) NSString *eventJoinUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
