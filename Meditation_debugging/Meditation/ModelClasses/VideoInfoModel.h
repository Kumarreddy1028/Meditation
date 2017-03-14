//
//  VideoInfoModel.h
//  Meditation
//
//  Created by IOS1-2016 on 02/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfoModel : NSObject
@property (strong, nonatomic) NSString *videoImageUrl;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) NSString *videoTitle;
@property (strong, nonatomic) NSString *videoDescription;
@property (strong, nonatomic) NSString *likesCount;
@property (strong, nonatomic) NSString *isLiked;
@property (strong, nonatomic) NSString *createdOn;

-(instancetype) initWithDictionary: (NSDictionary *) videoDetail;
@end
