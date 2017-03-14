//
//  MeditatorsTableViewCell.h
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeditatorsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *personImg;
@property (weak, nonatomic) IBOutlet UILabel *labelPersonName;
@property (weak, nonatomic) IBOutlet UILabel *labelLastSeen;

@end
