//
//  BooksCollectionViewCell.m
//  Meditation
//
//  Created by IOS-2 on 31/05/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "BooksCollectionViewCell.h"

@implementation BooksCollectionViewCell {
    
    __weak IBOutlet UILabel *_titleLabel;
}

-(void)configureStars
{
    float ratingFloat = [_bookRating floatValue];
    int ratingInteger = ratingFloat;
    for (int i = 1; i <= 5; i++)
    {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:i];
        if (button.tag <= ratingInteger) {
            [button setBackgroundImage:[UIImage imageNamed:@"books_rating_star_small"] forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"books_rating_star_small_unfill"] forState:UIControlStateNormal];
        }
        
    }
    if (ratingFloat - ratingInteger)
    {
        UIButton *button = (UIButton *)[self.contentView viewWithTag:ratingInteger + 1];
        [button setBackgroundImage:[UIImage imageNamed:@"books_rating_star_small_halffill"] forState:UIControlStateNormal];
    }
    [_titleLabel setText:_title];
}

@end
