//
//  MeditatorsModelClass.h
//  Meditation
//
//  Created by IOS1-2016 on 04/04/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeditatorsModelClass : NSObject

@property(nonatomic,strong) NSString *meditatorName;
@property(nonatomic,strong) NSString *meditatorImageUrl;
@property(nonatomic,strong) NSString *meditatorLastSeen;


- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
