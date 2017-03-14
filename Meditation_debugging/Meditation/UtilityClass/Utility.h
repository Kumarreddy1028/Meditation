//
//  Utility.h
//  Meditation
//
//  Created by IOS-2 on 01/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Utility : NSObject <CLLocationManagerDelegate>

+(Utility*)sharedInstance;

@property(nonatomic, strong)NSString *deviceToken;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *state;
@property(nonatomic, strong)NSString *onlineUsers;
@property(nonatomic, strong)NSString *downloadTopicId;
@property(nonatomic, assign)BOOL removeShareScene;
@property(nonatomic, assign)BOOL enterBackground;
@property(nonatomic, assign)BOOL isJoiningMeditation;

@property(nonatomic, assign)BOOL isDownloading, isFinished;

@property(nonatomic, assign)BOOL isDeviceIpad;
@property(nonatomic, assign)BOOL didFindLocation;
@property(nonatomic, assign)BOOL isFirstTimeShowDashboardAnimation;
@property(nonatomic, assign)CLLocationCoordinate2D annotationCoord;
@property(nonatomic, strong)CLLocationManager *locationManager;

+ (BOOL) isNetworkAvailable;
+ (NSMutableURLRequest *)getRequestWithData:(NSDictionary *)dict;
+(NSString *)userId;
+ (BOOL)isEmpty:(NSString *)text;
+(NSString *)changeDateFormat:(NSString *)str;
+(NSString *)changeTimeformat:(NSString*)time;

+ (NSString *)timeDifference:(NSDate *)fromDate ToDate:(NSString *)toDate;
+ (NSString *) userName;
+(NSString *) countryId;
-(NSString *)convertNumberIntoDepiction:(NSString *)strNumber;
-(NSString *)getDeviceToken;
-(void)registerDeviceTokenAtServer;
- (void)getCurrentLocationAndRegisterDeviceToken;
+ (NSDate *)getDateFromString:(NSString *)dateStr;
+(NSAttributedString *)placeholder:(NSString *)placeholderText;
+(NSMutableDictionary *)convertIntoUTF8:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary;
+(NSMutableDictionary *)convertIntoBase64:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary;
+(NSString *)uId;
+(NSAttributedString *)changePasswordplaceholder:(NSString *)placeholderText;
+(NSAttributedString *)changeLineSpacing:(NSString*)str;
+(NSMutableDictionary *)convertDictionaryIntoUTF8:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary;
+ (int) totalDurationFromString:(NSString *)duration;
+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate;
+(NSTimeInterval) getTimeDifference:(NSString *)dateString;
+(BOOL) isMeditationFinished;
+(BOOL)isPastDateLimitExceeds:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
