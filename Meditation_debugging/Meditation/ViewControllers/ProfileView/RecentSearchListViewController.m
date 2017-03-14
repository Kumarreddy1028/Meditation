//
//  RecentSearchListViewController.m
//  Ezevend
//
//  Created by apple on 21/12/15.
//  Copyright © 2015 iphone-08. All rights reserved.
//

#import "RecentSearchListViewController.h"

@interface RecentSearchListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *keywords, *searchResult;
}
@end

@implementation RecentSearchListViewController

#pragma mark - View Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate Methods.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.automaticPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [self.automaticPlaces objectAtIndex:indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectKeyword:[self.automaticPlaces objectAtIndex:indexPath.row]];
}

#pragma mark - Memory Management Method.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
