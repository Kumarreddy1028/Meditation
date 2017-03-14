//
//  MeditatorsViewController.m
//  Meditation
//
//  Created by IOS-01 on 09/02/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "MeditatorsViewController.h"
#import "MeditatorsTableViewCell.h"
#import "MeditatorsModelClass.h"
#import "UIImageView+WebCache.h"

@interface MeditatorsViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *arrMeditators;
}

@end

@implementation MeditatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrMeditators = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [self callServiceGetMeditatorsList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMeditators.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeditatorsModelClass *obj = [arrMeditators objectAtIndex:indexPath.row];
    MeditatorsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.labelPersonName.text = obj.meditatorName;
    cell.labelLastSeen.text = [NSString stringWithFormat:@"last post: %@",[self changeDateFormat:obj.meditatorLastSeen]];
    [cell.personImg sd_setImageWithURL:[NSURL URLWithString:obj.meditatorImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.personImg.layer.cornerRadius = (cell.personImg.frame.size.width / 2);
    cell.personImg.layer.masksToBounds = YES;
    return cell;
}

-(NSString *)changeDateFormat:(NSString *)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"dd-MM-yy hh:mm a"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    NSLog(@"%@", stringDate);
    
    return stringDate;
    
}


- (IBAction)backBtnActn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)callServiceGetMeditatorsList
{
    if ([Utility isNetworkAvailable])
    {
        NSMutableDictionary *dic= [[NSMutableDictionary alloc]init];
        [dic setObject:@"SERVICE_GET_MEDITATOR_LIST" forKey:@"REQUEST_TYPE_SENT"];
        [dic setObject:[Utility userId] forKey:User_Id];
        [dic setObject:[Utility userId] forKey:@"discussions_id"];

        [dic setObject:@"2" forKey:@"device_type"];
        [dic setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
        
        [SVProgressHUD show];
        NSMutableURLRequest *req= [Utility getRequestWithData:dic];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer
                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
          {
              [SVProgressHUD dismiss];
              if (!error) {
                  NSLog(@"Reply JSON: %@", responseObject);
                  if (responseObject[@"error_code"])
                      //if response object contains a key named error_code.
                  {
                      NSString *error_code=[responseObject objectForKey:@"error_code"];
                      NSString *error_desc=[responseObject objectForKey:@"error_desc"];
                      UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:error_code message:error_desc preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      [myAlert addAction:action];
                      [self presentViewController:myAlert animated:YES completion:nil];
                  }
                  else
                  {
                      //successfully got chats.
                      NSArray *meditators = [responseObject objectForKey:@"meditators_list"];
                      for (NSDictionary *dict in meditators)
                      {
                          MeditatorsModelClass *obj = [[MeditatorsModelClass alloc]initWithDictionary:dict];
                          [arrMeditators addObject:obj];
                      }
                      [self.tableView reloadData];
                  }
              }
              else
              {
                  NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                  UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                  [myAlert addAction:action];
                  [self presentViewController:myAlert animated:YES completion:nil];
                  
              }
          }] resume];
    }
    else
    {
        [self.view makeToast:@"Network connection seems to be offline"];
    }
    
}

@end
