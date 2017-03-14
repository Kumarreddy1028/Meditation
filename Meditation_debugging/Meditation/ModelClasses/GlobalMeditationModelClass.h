//
//  GlobalMeditationModelClass.h
//  Meditation
//
//  Created by IOS-2 on 14/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMeditationModelClass : NSObject

@property(nonatomic,strong) NSString *isLiked;
@property(nonatomic,strong) NSString *musicFileName;
@property(nonatomic,strong) NSString *musicImageName;
@property(nonatomic,strong) NSString *startDate;
@property(nonatomic,strong) NSString *topicId;
@property(nonatomic,strong) NSString *isJoined;
@property(nonatomic,strong) NSString *totalLikeCount;
@property(nonatomic,strong) NSString *countries;
@property(nonatomic,strong) NSString *meditators;
@property(nonatomic,strong) NSString *duration;
@property(nonatomic,strong) NSString *musicfilemp3;
@property(nonatomic,strong) NSString *colorCode;
@property (nonatomic, strong) NSDate *startDt;
@property (nonatomic, strong) NSNumber *timer;




- (instancetype)initWithDictionary:(NSDictionary *)meditateNow;

@end
