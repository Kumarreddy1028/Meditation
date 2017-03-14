//
//  BooksModelClass.h
//  Meditation
//
//  Created by IOS1-2016 on 07/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BooksModelClass : NSObject

@property(nonatomic,strong) NSString *bookId;
@property(nonatomic,strong) NSString *bookName;
@property(nonatomic,strong) NSString *bookSubtitle;
@property(nonatomic,strong) NSString *bookDescription;
@property(nonatomic,strong) NSString *bookUrl;
@property(nonatomic,strong) NSString *countryUrl;
@property(nonatomic,strong) NSString *bookRating;
@property(nonatomic,strong) NSString *bookPrice;
@property(nonatomic,strong) NSString *bookImageUrl;
@property(nonatomic,strong) NSString *overview;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
