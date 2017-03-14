//
//  MeditateNowModelClass.h
//  Meditation
//
//  Created by IOS-01 on 02/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeditateNowModelClass : NSObject

@property(nonatomic,strong) NSString *duration;
@property(nonatomic,strong) NSString *endDate;
@property(nonatomic,strong) NSString *guidedFileName;
@property(nonatomic,strong) NSString *guidedImageName;
@property(nonatomic,strong) NSString *isLiked;
@property(nonatomic,strong) NSString *likeCounts;
@property(nonatomic,strong) NSString *musicFileName;
@property(nonatomic,strong) NSString *musicImageName;
@property(nonatomic,strong) NSString *startDate;
@property(nonatomic,strong) NSString *topicId;
@property(nonatomic,strong) NSString *topicName;
@property(nonatomic,strong) NSString *topicDescription;
@property(nonatomic,strong) NSString *backgroudImage;
@property(nonatomic,strong) NSString *guidedMp3File;
@property(nonatomic,strong) NSString *musicMp3File;
@property(nonatomic,strong) NSString *musicColorCode;
@property(nonatomic,strong) NSString *guidedColorCode;

- (instancetype)initWithDictionary:(NSDictionary *)meditateNow;

@end
