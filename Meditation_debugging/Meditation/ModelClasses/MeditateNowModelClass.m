//
//  MeditateNowModelClass.m
//  Meditation
//
//  Created by IOS-01 on 02/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "MeditateNowModelClass.h"

@implementation MeditateNowModelClass

- (instancetype)initWithDictionary:(NSDictionary *)meditateNow
{
        if ([[meditateNow objectForKey:@"duration"] isKindOfClass:[NSNull class]] )
            self.duration = @"";
        else
            self.duration = [meditateNow objectForKey:@"duration"];
    
        if ([[meditateNow objectForKey:@"topic_description"] isKindOfClass:[NSNull class]] )
            self.topicDescription = @"";
        else
            self.topicDescription = [meditateNow objectForKey:@"topic_description"];
    
        if ([[meditateNow objectForKey:@"end_date"] isKindOfClass:[NSNull class]] )
            self.endDate = @"";
        else
            self.endDate = [meditateNow objectForKey:@"end_date"];

        if ([[meditateNow objectForKey:@"guided_file_name"] isKindOfClass:[NSNull class]] )
            self.guidedFileName = @"";
        else
            self.guidedFileName = [meditateNow objectForKey:@"guided_file_name"];
    
        if ([[meditateNow objectForKey:@"guided_image_name"] isKindOfClass:[NSNull class]] )
            self.guidedImageName = @"";
        else
            self.guidedImageName = [meditateNow objectForKey:@"guided_image_name"];
        
        if ([[meditateNow objectForKey:@"is_liked"] isKindOfClass:[NSNull class]] )
            self.isLiked = @"";
        else
            self.isLiked = [meditateNow objectForKey:@"is_liked"];
        
        if ([[meditateNow objectForKey:@"like_counts"] isKindOfClass:[NSNull class]] )
            self.likeCounts = @"";
        else
            self.likeCounts = [meditateNow objectForKey:@"like_counts"];
        
        if ([[meditateNow objectForKey:@"music_file_name"] isKindOfClass:[NSNull class]] )
            self.musicFileName = @"";
        else
            self.musicFileName = [meditateNow objectForKey:@"music_file_name"];
        
        if ([[meditateNow objectForKey:@"music_image_name"] isKindOfClass:[NSNull class]] )
            self.musicImageName = @"";
        else
            self.musicImageName = [meditateNow objectForKey:@"music_image_name"];
        
        if ([[meditateNow objectForKey:@"start_date"] isKindOfClass:[NSNull class]] )
            self.startDate = @"";
        else
            self.startDate = [meditateNow objectForKey:@"start_date"];
        
        if ([[meditateNow objectForKey:@"topic_id"] isKindOfClass:[NSNull class]] )
            self.topicId = @"";
        else
            self.topicId = [meditateNow objectForKey:@"topic_id"];
        
        if ([[meditateNow objectForKey:@"topic_name"] isKindOfClass:[NSNull class]] )
            self.topicName = @"";
        else
            self.topicName = [meditateNow objectForKey:@"topic_name"];
    
        if ([[meditateNow objectForKey:@"background_image"] isKindOfClass:[NSNull class]] )
            self.backgroudImage = @"";
        else
            self.backgroudImage = [meditateNow objectForKey:@"background_image"];
        if ([[meditateNow objectForKey:@"guide_mp3_file"] isKindOfClass:[NSNull class]] )
            self.guidedMp3File = @"";
        else
            self.guidedMp3File = [meditateNow objectForKey:@"guide_mp3_file"];
        if ([[meditateNow objectForKey:@"music_mp3_file"] isKindOfClass:[NSNull class]] )
            self.musicMp3File = @"";
        else
            self.musicMp3File = [meditateNow objectForKey:@"music_mp3_file"];
        if ([[meditateNow objectForKey:@"music_color_code"] isKindOfClass:[NSNull class]] )
            self.musicColorCode = @"";
        else
            self.musicColorCode = [meditateNow objectForKey:@"music_color_code"];
        if ([[meditateNow objectForKey:@"guided_color_code"] isKindOfClass:[NSNull class]] )
            self.guidedColorCode = @"";
        else
            self.guidedColorCode = [meditateNow objectForKey:@"guided_color_code"];
    
    return self;
}

@end
