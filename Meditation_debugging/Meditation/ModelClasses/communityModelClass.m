//
//  communityModelClass.m
//  Meditation
//
//  Created by IOS-01 on 09/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "communityModelClass.h"

@implementation communityModelClass
-(instancetype) initWithDictionary: (NSDictionary *) community
{
    if ([[community objectForKey:@"event_id"] isKindOfClass:[NSNull class]] )
    {
        self.eventID = @"";
    }
    else
    {
        self.eventID = [community objectForKey:@"event_id"];
        
        NSLog(@" %@",self.eventID);
    }
    if ([[community objectForKey:@"event_name"] isKindOfClass:[NSNull class]] )
    {
        self.eventName = @"";
    }
    else
    {
        self.eventName = [community objectForKey:@"event_name"];
        
        NSLog(@" %@",self.eventName);
    }
    if ([[community objectForKey:@"end_on"] isKindOfClass:[NSNull class]] )
    {
        self.endOn = @"";
    }
    else
    {
        self.endOn = [community objectForKey:@"end_on"];
        
        NSLog(@" %@",self.endOn);
    }
    if ([[community objectForKey:@"starts_on"] isKindOfClass:[NSNull class]] )
    {
        self.startOn = @"";
    }
    else
    {
        self.startOn = [community objectForKey:@"starts_on"];
        
        NSLog(@" %@",self.startOn);
    }

    if ([[community objectForKey:@"event_venue"] isKindOfClass:[NSNull class]] )
    {
        self.eventVenue = @"";
    }
    else
    {
        self.eventVenue = [community objectForKey:@"event_venue"];
        
        NSLog(@" %@",self.eventVenue);
    }
    if ([[community objectForKey:@"event_description"] isKindOfClass:[NSNull class]] )
    {
        self.eventDescription = @"";
    }
    else
    {
        self.eventDescription = [community objectForKey:@"event_description"];
        
        NSLog(@" %@",self.eventDescription);
    }
    if ([[community objectForKey:@"Registered"] isKindOfClass:[NSNull class]] )
    {
        self.isRegistered = @"0";
    }
    else
    {
        self.isRegistered = [community objectForKey:@"Registered"];
        
        NSLog(@" %@",self.eventDescription);
    }
    if ([[community objectForKey:@"event_city"] isKindOfClass:[NSNull class]] )
    {
        self.eventCity = @"";
    }
    else
    {
        self.eventCity = [community objectForKey:@"event_city"];
    }
    if ([[community objectForKey:@"event_pincode"] isKindOfClass:[NSNull class]] )
    {
        self.eventPincode = @"";
    }
    else
    {
        self.eventPincode = [community objectForKey:@"event_pincode"];
        
    }
    if ([[community objectForKey:@"event_state"] isKindOfClass:[NSNull class]] )
    {
        self.eventState = @"";
    }
    else
    {
        self.eventState = [community objectForKey:@"event_state"];
        
    }
    if ([[community objectForKey:@"event_venue"] isKindOfClass:[NSNull class]] )
    {
        self.eventVenue = @"0";
    }
    else
    {
        self.eventVenue = [community objectForKey:@"event_venue"];
        
    }
    if ([[community objectForKey:@"heading"] isKindOfClass:[NSNull class]] )
    {
        self.heading = @"";
    }
    else
    {
        self.heading = [community objectForKey:@"heading"];
        
    }
    if ([[community objectForKey:@"seat"] isKindOfClass:[NSNull class]] )
    {
        self.seat = @"0";
    }
    else
    {
        self.seat = [community objectForKey:@"seat"];
        
    }

    return self;
    
}


@end
