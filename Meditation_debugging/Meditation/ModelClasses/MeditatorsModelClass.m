//
//  MeditatorsModelClass.m
//  Meditation
//
//  Created by IOS1-2016 on 04/04/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "MeditatorsModelClass.h"

@implementation MeditatorsModelClass

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"name"] isKindOfClass:[NSNull class]] )
        self.meditatorName = @"";
    else
        self.meditatorName = [dict objectForKey:@"name"];
    
    if ([[dict objectForKey:@"image_name"] isKindOfClass:[NSNull class]] )
        self.meditatorImageUrl = @"";
    else
        self.meditatorImageUrl = [dict objectForKey:@"image_name"];
    
    if ([[dict objectForKey:@"last_post"] isKindOfClass:[NSNull class]] )
        self.meditatorLastSeen = @"";
    else
        self.meditatorLastSeen = [dict objectForKey:@"last_post"];
    
    return self;
}
@end
