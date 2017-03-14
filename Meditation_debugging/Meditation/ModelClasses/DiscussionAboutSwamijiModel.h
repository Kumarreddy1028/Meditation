//
//  DiscussionAboutSwamijiModel.h
//  Meditation
//
//  Created by IOS1-2016 on 18/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscussionAboutSwamijiModel : NSObject
@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) NSString *message;
-(instancetype)initWithUserID:(NSString *)userID andMessage:(NSString *)message;

@end
