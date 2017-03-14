//
//  BooksModelClass.m
//  Meditation
//
//  Created by IOS1-2016 on 07/06/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "BooksModelClass.h"

@implementation BooksModelClass

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"id"] isKindOfClass:[NSNull class]] )
        self.bookId = @"";
    else
        self.bookId = [dict objectForKey:@"id"];
    
    if ([[dict objectForKey:@"book_url"] isKindOfClass:[NSNull class]] )
        self.bookUrl = @"";
    else
        self.bookUrl = [dict objectForKey:@"book_url"];
    if ([[dict objectForKey:@"country_url"] isKindOfClass:[NSNull class]] )
        self.countryUrl = @"";
    else
        self.countryUrl = [dict objectForKey:@"country_url"];
    
    if ([[dict objectForKey:@"name"] isKindOfClass:[NSNull class]] )
        self.bookName = @"";
    else
        self.bookName = [dict objectForKey:@"name"];
    
    if ([[dict objectForKey:@"sub_title"] isKindOfClass:[NSNull class]] )
        self.bookSubtitle = @"";
    else
        self.bookSubtitle = [dict objectForKey:@"sub_title"];
    
    if ([[dict objectForKey:@"description"] isKindOfClass:[NSNull class]] )
        self.bookDescription = @"";
    else
        self.bookDescription = [dict objectForKey:@"description"];
    
    if ([[dict objectForKey:@"rating"] isKindOfClass:[NSNull class]] )
        self.bookRating = @"";
    else
        self.bookRating = [dict objectForKey:@"rating"];
    
    if ([[dict objectForKey:@"price"] isKindOfClass:[NSNull class]] )
        self.bookPrice = @"";
    else
        self.bookPrice = [dict objectForKey:@"price"];
    
    if ([[dict objectForKey:@"book_image"] isKindOfClass:[NSNull class]] )
        self.bookImageUrl = @"";
    else
        self.bookImageUrl = [dict objectForKey:@"book_image"];
    
    if ([[dict objectForKey:@"overview"] isKindOfClass:[NSNull class]] )
        self.overview = @"";
    else
        self.overview = [dict objectForKey:@"overview"];
    
    return self;
}

@end
