//
//  VideoInfoModel.m
//  Meditation
//
//  Created by IOS1-2016 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "VideoInfoModel.h"

@implementation VideoInfoModel
-(instancetype) initWithDictionary: (NSDictionary *) videoDetail
{
    self.videoImageUrl = [videoDetail objectForKey:@"image_file_name"];
    self.videoId = [videoDetail objectForKey:@"id"];
    self.videoTitle = [videoDetail objectForKey:@"name"];
    self.videoDescription = [videoDetail objectForKey:@"video_description"];
    self.likesCount = [videoDetail objectForKey:@"like_counts"];
    self.videoUrl = [videoDetail objectForKey:@"video_file_name"];
    self.isLiked = [videoDetail objectForKey:@"is_liked"];
    self.createdOn = [videoDetail objectForKey:@"published_date"];
    self.videoImageUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg", [[videoDetail[@"video_file_name"] lastPathComponent] stringByReplacingOccurrencesOfString:@"watch?v=" withString:@""]];;
    return self;
}
@end
