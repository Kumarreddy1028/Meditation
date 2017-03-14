//
//  BooksCollectionViewCell.h
//  Meditation
//
//  Created by IOS-2 on 31/05/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) NSString *bookRating;
@property (nonatomic, strong) NSString *title;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

-(void)configureStars;

@end
