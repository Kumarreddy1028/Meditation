//
//  BooksViewController.h
//  Meditation
//
//  Created by IOS-2 on 31/05/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksViewController : UIViewController
//@property(strong, nonatomic) NSString *bookTitle;
//@property(strong, nonatomic) NSString *bookSubSubtitle;
//@property(strong, nonatomic) NSString *bookDescription;
//@property(strong, nonatomic) NSString *bookPrice;
//@property(strong, nonatomic) NSString *bookStarRating;
@property (weak, nonatomic) IBOutlet UIButton *btnBook;
@property (weak, nonatomic) IBOutlet UICollectionView *booksCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblBookTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBookSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBookDescription;
@property (weak, nonatomic) IBOutlet UIView *gastureView;
@property (weak, nonatomic) IBOutlet UILabel *lblBookPrice;
- (IBAction)shareBtnActn:(id)sender;

- (IBAction)buyBookBtnActn:(id)sender;

- (IBAction)menuBtnActn:(id)sender;
- (IBAction)bookButtonAction:(id)sender;

- (IBAction)dashboardBtnActn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBook;
@property (weak, nonatomic) IBOutlet UIButton *buyBook;

@end
