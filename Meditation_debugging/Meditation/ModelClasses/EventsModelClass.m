//
//  EventsModelClass.m
//  Meditation
//
//  Created by IOS1-2016 on 06/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "EventsModelClass.h"

@implementation EventsModelClass

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"event_name"] isKindOfClass:[NSNull class]] )
        self.eventName = @"";
    else
        self.eventName = [dict objectForKey:@"event_name"];
    
    if ([[dict objectForKey:@"event_venue"] isKindOfClass:[NSNull class]] )
        self.eventVenue = @"";
    else
        self.eventVenue = [dict objectForKey:@"event_venue"];
    
    if ([[dict objectForKey:@"event_description"] isKindOfClass:[NSNull class]] )
        self.eventDescription = @"";
    else
        self.eventDescription = [dict objectForKey:@"event_description"];
    
    
    if ([[dict objectForKey:@"starts_on"] isKindOfClass:[NSNull class]] )
        self.eventStartsOn = @"";
    else
        self.eventStartsOn = [dict objectForKey:@"starts_on"];
    if ([[dict objectForKey:@"end_on"] isKindOfClass:[NSNull class]] )
        self.eventEndsOn = @"";
    else
        self.eventEndsOn = [dict objectForKey:@"end_on"];

    if ([[dict objectForKey:@"url"] isKindOfClass:[NSNull class]] )
        self.eventJoinUrl = @"";
    else
        self.eventJoinUrl = [dict objectForKey:@"url"];

    return self;
}

@end
