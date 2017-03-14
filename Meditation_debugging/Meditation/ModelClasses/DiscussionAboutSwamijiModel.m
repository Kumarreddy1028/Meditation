//
//  DiscussionAboutSwamijiModel.m
//  Meditation
//
//  Created by IOS1-2016 on 18/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "DiscussionAboutSwamijiModel.h"

@implementation DiscussionAboutSwamijiModel
-(instancetype)initWithUserID:(NSString *)userID andMessage:(NSString *)message
{
    self.userID = userID;
    self.message = message;
    return self;
}
@end
