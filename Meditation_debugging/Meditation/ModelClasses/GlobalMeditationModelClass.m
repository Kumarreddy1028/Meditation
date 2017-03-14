//
//  GlobalMeditationModelClass.m
//  Meditation
//
//  Created by IOS-2 on 14/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "GlobalMeditationModelClass.h"

@implementation GlobalMeditationModelClass

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"is_join"] isKindOfClass:[NSNull class]] )
        self.isJoined = @"";
    else
        self.isJoined = [dict objectForKey:@"is_join"];
   
    if ([[dict objectForKey:@"duration"] isKindOfClass:[NSNull class]] )
        self.duration = @"";
    else
        self.duration = [dict objectForKey:@"duration"];

    
    if ([[dict objectForKey:@"is_liked"] isKindOfClass:[NSNull class]] )
        self.isLiked = @"";
    else
        self.isLiked = [dict objectForKey:@"is_liked"];
    
    if ([[dict objectForKey:@"music_file_name"] isKindOfClass:[NSNull class]] )
        self.musicFileName = @"";
    else
        self.musicFileName = [dict objectForKey:@"music_file_name"];
    
    
    if ([[dict objectForKey:@"music_image_name"] isKindOfClass:[NSNull class]] )
        self.musicImageName = @"";
    else
        self.musicImageName = [dict objectForKey:@"music_image_name"];
    
    
    if ([[dict objectForKey:@"start_date"] isKindOfClass:[NSNull class]] )
        self.startDate = nil;
    else {
        self.startDate = [dict objectForKey:@"start_date"];
        self.startDt = [self utcDateFromDateString:self.startDate];
    }
    
    
    
    if ([[dict objectForKey:@"topic_id"] isKindOfClass:[NSNull class]] )
        self.topicId = @"";
    else
        self.topicId = [dict objectForKey:@"topic_id"];
    
    
    if ([[dict objectForKey:@"total_like_count"] isKindOfClass:[NSNull class]] )
        self.totalLikeCount = @"";
    else
        self.totalLikeCount = [dict objectForKey:@"total_like_count"];
    
    if ([[dict objectForKey:@"meditator_count"] isKindOfClass:[NSNull class]] )
        self.meditators = @"";
    else
        self.meditators = @"";
        self.meditators = [dict objectForKey:@"meditator_count"];
    
    if ([[dict objectForKey:@"country_count"] isKindOfClass:[NSNull class]] )
        self.countries = @"";
    else
        self.countries = [dict objectForKey:@"country_count"];
    if ([[dict objectForKey:@"music_file_mp3"] isKindOfClass:[NSNull class]] )
        self.musicfilemp3 = @"";
    else
        self.musicfilemp3 = [dict objectForKey:@"music_file_mp3"];

    if ([[dict objectForKey:@"color_code"] isKindOfClass:[NSNull class]] )
        self.colorCode = @"";
    else
        self.colorCode = [dict objectForKey:@"color_code"];
    return self;
}

- (NSDate *)utcDateFromDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [dateFormatter dateFromString:dateString];
}

//- (NSNumber *)timerFromDate:(NSString *)dateString {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    return [NSNumber numberWithInteger]
////    return [dateFormatter ];
//}

@end
