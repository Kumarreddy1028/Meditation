//
//  communityModelClass.h
//  Meditation
//
//  Created by IOS-01 on 09/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface communityModelClass : NSObject
@property(nonatomic,strong) NSString *eventID;
@property(nonatomic,strong) NSString *eventName;
@property(nonatomic,strong) NSString *endOn;
@property(nonatomic,strong) NSString *startOn;
@property(nonatomic,strong) NSString *eventVenue;
@property(nonatomic,strong) NSString *eventDescription;
@property(nonatomic,strong) NSString *isRegistered;
@property(nonatomic,strong) NSString *eventCity;
@property(nonatomic,strong) NSString *eventPincode;
@property(nonatomic,strong) NSString *eventState;
@property(nonatomic,strong) NSString *heading;
@property(nonatomic,strong) NSString *seat;

-(instancetype) initWithDictionary: (NSDictionary *) community;



@end
