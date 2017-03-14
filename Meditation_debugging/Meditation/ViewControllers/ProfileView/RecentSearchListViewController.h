//
//  RecentSearchListViewController.h
//  Ezevend
//
//  Created by apple on 21/12/15.
//  Copyright © 2015 iphone-08. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecentSearchDelegate <NSObject>

- (void)selectKeyword:(NSString *)keyword;

@end

@interface RecentSearchListViewController : UIViewController

@property (nonatomic, weak) id<RecentSearchDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *automaticPlaces;


@end
