//
//  NewsModelClass.h
//  Meditation
//
//  Created by IOS1-2016 on 03/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModelClass : NSObject

@property(nonatomic,strong) NSString *newsId;
@property(nonatomic,strong) NSString *newsTitle;
@property(nonatomic,strong) NSString *newsDescription;
@property(nonatomic,strong) NSString *newsContent;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
