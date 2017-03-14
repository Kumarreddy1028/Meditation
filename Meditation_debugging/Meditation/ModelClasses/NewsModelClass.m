//
//  NewsModelClass.m
//  Meditation
//
//  Created by IOS1-2016 on 03/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "NewsModelClass.h"

@implementation NewsModelClass

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"id"] isKindOfClass:[NSNull class]] )
        self.newsId = @"";
    else
        self.newsId = [dict objectForKey:@"id"];
    
    if ([[dict objectForKey:@"title"] isKindOfClass:[NSNull class]] )
        self.newsTitle = @"";
    else
        self.newsTitle = [dict objectForKey:@"title"];
    
    if ([[dict objectForKey:@"description"] isKindOfClass:[NSNull class]] )
        self.newsDescription = @"";
    else
        self.newsDescription = [dict objectForKey:@"description"];

    
    if ([[dict objectForKey:@"content"] isKindOfClass:[NSNull class]] )
        self.newsContent = @"";
    else
        self.newsContent = [dict objectForKey:@"content"];
    return self;
}

@end
