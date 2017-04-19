//
//  Utility.m
//  Meditation
//
//  Created by IOS-2 on 01/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

static Utility *__utility;
@implementation Utility

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.profImage = nil;
    }
    return self;
}

+(Utility*)sharedInstance
{
    if(!__utility) {
        __utility = [[[self class] alloc] init];
        
    }
    return __utility;
}

-(NSString *)getDeviceToken
{
    if (self.deviceToken.length != 0) {
        return self.deviceToken;
    }
    else
    {
        return @"";
    }
}

// Check Intenet availability
+ (BOOL) isNetworkAvailable
{
    Reachability *reachability	= [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert"
                                      message:@"Network not available."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alert addAction:okAction];
        UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

+ (NSMutableURLRequest *)getRequestWithData:(NSMutableDictionary *)dict
{
    NSMutableDictionary *base64Dict = [self convertIntoBase64:[dict allValues] dictionary:dict];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:base64Dict options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:Server_Url parameters:nil error:&error];
    
    req.timeoutInterval= 30.0;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setValue:@"1" forHTTPHeaderField:Decode];
    [req setValue:@"2" forHTTPHeaderField:Zipjson];

    return req;
}

+(NSString *)userId
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"u_id"];
    if ([userId isKindOfClass:[NSNull class]] || userId == nil)
    {
        userId = @"";
    }
    return userId;
}

+(NSString *)uId
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"u_id"];
    if ([userId isKindOfClass:[NSNull class]] || userId == nil)
    {
        userId = @"0";
    }
    return userId;
}


+ (BOOL)isEmpty:(NSString *)text
{
    if ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        return YES;
    else
        return NO;
}

+(NSString *)changeDateFormat:(NSString *)str
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    
    dateFromString = [dateFormatter dateFromString:str];
    
    [dateFormatter setDateFormat:@"EEE, dd.MM.yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:dateFromString];
    NSLog(@"%@", stringDate);
    stringDate=[NSString stringWithFormat:@"%@%@", [[stringDate substringToIndex:3] lowercaseString], [stringDate substringFromIndex:3]];
    NSString *timeStr=stringDate;
    NSArray* timeArr=[timeStr componentsSeparatedByString:@"."];
    NSArray *dayarr = [[timeArr objectAtIndex:0] componentsSeparatedByString:@","];
    NSString *dayStr = [NSString stringWithFormat:@"%@, %d",[dayarr objectAtIndex:0],[[dayarr objectAtIndex:1] intValue]];
    stringDate = [NSString stringWithFormat:@"%@.%d.%@",dayStr,[[timeArr objectAtIndex:1] intValue],[timeArr objectAtIndex:2]];
    return stringDate;
    
}



+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate {
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    
    if (days > 0) {
        
        if (days > 1) {
            durationString = [NSString stringWithFormat:@"%ld days", (long)days];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld day", (long)days];
        }
        return durationString;
    }
    
    if (hour > 0) {
        
        if (hour > 1) {
            durationString = [NSString stringWithFormat:@"%ld hours", (long)hour];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld hour", (long)hour];
        }
        return durationString;
    }
    
    if (minutes > 0) {
        
        if (minutes > 1) {
            durationString = [NSString stringWithFormat:@"%ld minutes", (long)minutes];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld minute", (long)minutes];
        }
        return durationString;
    }
    
    return @"";
}

+(BOOL)isPastDateLimitExceeds:(NSDate*)startDate endDate:(NSDate*)endDate {
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitHour|kCFCalendarUnitMinute
                                                 fromDate: startDate toDate: endDate options: 0];
//    days = [components day];
    minutes = [components minute];
    hour = [components hour];
    NSLog(@"hours %ld, days %ld, minutes %ld", hour, days, minutes);
    if (labs(minutes) >= 4320) {// Meditation past date checking(more than 3 days)
        return true;
    }
    return false;
}

//+(void) isMeditationFinished {
//    return isFinished;
//}

- (UIImage *) profileImage {
    if (self.profImage == nil) {
        NSString *imageUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"profileImageUrl"];
        
        NSData *imageData = [NSData dataWithContentsOfFile:imageUrl];
        if (imageData) {
            self.profImage = [UIImage imageWithData:imageData];
        }
    }
    
    
    return self.profImage;
}

+(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

+ (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


+ (int) totalDurationFromString:(NSString *)duration
{
    NSArray *timeArray = [duration componentsSeparatedByString:@":"];
    NSString *hourString = [timeArray objectAtIndex:0];
    NSString *minuteString = [timeArray objectAtIndex:1];
    NSString *secondString = [timeArray objectAtIndex:2];
    int hourDuration = [hourString intValue];
    int minuteDuration = [minuteString intValue];
    int secondDuration = [secondString intValue];
    return (secondDuration + minuteDuration*60 + hourDuration*60*60);
}

+(NSDate *) dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}


+(NSTimeInterval) getTimeDifference:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDate *startDate = [dateFormatter dateFromString:dateString];
    return [startDate timeIntervalSinceNow];
}


+ (NSString *)timeDifference:(NSDate *)fromDate ToDate:(NSString *)toDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *dateFromString = [dateFormatter dateFromString:toDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *differenceValue = [calendar components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:fromDate toDate:dateFromString options:0];
    NSString *days = [NSString stringWithFormat:@"%02ld",(long)[differenceValue day]];
    NSString *hours = [NSString stringWithFormat:@"%02ld",(long)[differenceValue hour]];
    NSString *minuts = [NSString stringWithFormat:@"%02ld",(long)[differenceValue minute]];
    NSString *seconds = [NSString stringWithFormat:@"%02ld",(long)[differenceValue second]];

    if ([differenceValue day] < 0 || [differenceValue hour] < 0 || [differenceValue minute] < 0 ||[differenceValue second] < 0)
    {
        return @"00:00:00";
    }
    NSString *remainingTime = [NSString stringWithFormat:@"%@:%@:%@:%@",days,hours,minuts,seconds];
    
    return remainingTime;
}

+ (NSDate *)getDateFromString:(NSString *)dateStr
{
    NSTimeZone *outputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:outputTimeZone];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}

+ (NSString *) userName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    if ([userName isKindOfClass:[NSNull class]] || userName == nil)
    {
        userName = @"";
    }
    return userName;
}

+(NSString *) countryId
{
    NSString *countryId = [[NSUserDefaults standardUserDefaults] objectForKey:@"country_id"];
    if ([countryId isKindOfClass:[NSNull class]] || countryId == nil)
    {
        countryId = @"";
    }
    return countryId;
}

-(void)registerDeviceTokenAtServer
{
    //----WEB SERVICES---------//
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_REGISTER_DEVICE_TOKEN" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:@"2" forKey:@"device_type"];
    [dict setObject:[Utility userId] forKey:@"user_id"];
    [dict setObject:[NSString stringWithFormat:@"%f",self.annotationCoord.latitude] forKey:@"latitude"];
    [dict setObject:[NSString stringWithFormat:@"%f",self.annotationCoord.longitude] forKey:@"longitude"];
    [dict setObject:[self getDeviceToken] forKey:@"device_token"];

    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error)
      {
          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              if (responseObject[@"error_code"])
              {
                 
              }
              else
              {
                 
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
              
          }
      }] resume];
}

-(NSString *)convertNumberIntoDepiction:(NSString *)strNumber
{
    int number = [strNumber intValue];
    NSString * depictedNumber;

    if (number <1000)
    {
        depictedNumber=[NSString stringWithFormat:@"%d",number];
        
    }
    else if (number >= 1000 && number < 1000000 )
    {
       
        depictedNumber= [self abbreviateNumber:number withDecimal:1000];
    }
    else if (number >= 1000000 && number < 1000000000 )
    {
        depictedNumber= [self abbreviateNumber:number withDecimal:1000000];
    }
    else
    {
        depictedNumber= [self abbreviateNumber:number withDecimal:1000000000];
    }
    return depictedNumber;

}

- (void)getCurrentLocationAndRegisterDeviceToken
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
        _didFindLocation = NO;
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [_locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [_locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    [_locationManager startUpdatingLocation];
}

-(NSString *)abbreviateNumber:(int)num withDecimal:(int)dec {
    
    NSString *abbrevNum;
    float number = (float)num;
    
    NSArray *abbrev = @[@"k", @"m", @"b"];
    
    for (NSInteger i = abbrev.count - 1; i >= 0; i--) {
        
        // Convert array index to "1000", "1000000", etc
        int size = pow(10,(i+1)*3);
        
        if(size <= number) {
            // Here, we multiply by decPlaces, round, and then divide by decPlaces.
            // This gives us nice rounding to a particular decimal place.
            number = round(number*dec/size)/dec;
            
            NSString *numberString = [self floatToString:number];
            
            // Add the letter for the abbreviation
            abbrevNum = [NSString stringWithFormat:@"%@%@", numberString, [abbrev objectAtIndex:i]];
            
            NSLog(@"%@", abbrevNum);
            
        }
        
    }
    
    
    return abbrevNum;
}

- (NSString *) floatToString:(float) val {
    
    NSString *ret = [NSString stringWithFormat:@"%.1f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];
    
    while (c == 48 || c == 46) { // 0 or .
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];
    }
    
    return ret;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //[self switchToHomeScreen];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    if (!_didFindLocation) {
        _didFindLocation = YES;
        [_locationManager stopUpdatingLocation];
        _annotationCoord = newLocation.coordinate;
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
        [Utility sharedInstance].annotationCoord = _annotationCoord;
            [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                //..NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                if (error == nil && [placemarks count] > 0)
                {
                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                    
                    placemark = [placemarks lastObject];
                    [Utility sharedInstance].country = placemark.country;
                    [Utility sharedInstance].state = placemark.locality;
                   
                } else {
                }
            } ];
        if (![Utility sharedInstance].isJoiningMeditation) {
            [self registerDeviceTokenAtServer];
        }
    }
}

+(NSAttributedString *)placeholder:(NSString *)placeholderText
{
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    return attributedPlaceholder;
}

+(NSAttributedString *)changePasswordplaceholder:(NSString *)placeholderText
{
    NSAttributedString *attributedPlaceholder;
    if ([Utility sharedInstance].isDeviceIpad)
    {
     attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Regular" size:21.0] }];
    }
    else
    {
       attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Regular" size:17.0] }];
        
    }
    return attributedPlaceholder;
}
+ (NSMutableDictionary *)convertIntoBase64:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary {
    
    for (id value in valuesArray) {
        
        // if dictonary contains string values
        if ([value isKindOfClass:[NSString class]]) {
            NSString *base64String = [self base64StringEncodeFromString:value];
            for (NSString *key in [dictionary allKeys]) {
                if ([[dictionary objectForKey:key] isKindOfClass:[NSString class]]) {
                    if ([[dictionary objectForKey:key] isEqualToString:value]) {
                        [dictionary setObject:base64String forKey:key];
                    }
                }
            }
        }
        
        //if dictionary contains an array as value
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray* allKeyArray = [dictionary allKeys];
            NSString* arrayName = @"";
            for (NSString* key in allKeyArray) {
                if ([dictionary valueForKey:key] == value)
                {
                    arrayName = key;
                }
            }
            
            NSMutableArray *valueCopy = [value mutableCopy];
            for (int j = 0; j < valueCopy.count; j++) {
                id key = [valueCopy objectAtIndex:j];
                
                //if array contains dictionary as value
                if ([key isKindOfClass:[NSDictionary class]]) {
                    [self convertIntoBase64:[key allValues] dictionary:key];
                }
                
                //if array contains string values
                else if ([key isKindOfClass:[NSString class]]) {
                    NSString *utf8String = [self base64StringEncodeFromString:key];
                    for (int i = 0; i < valueCopy.count; i++) {
                        if ([[valueCopy objectAtIndex:i] isEqualToString:key]) {
                            [valueCopy replaceObjectAtIndex:i withObject:utf8String];
                        }
                    }
                }
            }
            
            [dictionary setObject:valueCopy forKey:arrayName];
        }
        
        // if dictonary contains dictionary as value
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self convertIntoBase64:[value allValues] dictionary:value];
        }
    }
    
    return dictionary;
}

+(NSMutableDictionary *)convertIntoUTF8:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary
{
    if ([[dictionary objectForKey:[[dictionary allKeys] firstObject]] isKindOfClass:[NSArray class]]) {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in [dictionary objectForKey:[[dictionary allKeys] firstObject]]) {
            NSDictionary *convertedDict = [Utility convertDictionaryIntoUTF8:[dict allValues] dictionary:[dict mutableCopy]];
            [values addObject:convertedDict];
        }
        dictionary = [NSMutableDictionary dictionaryWithObject:values forKey:[[dictionary allKeys] firstObject]];
        return dictionary;
    }
    else
    {
        return [Utility convertDictionaryIntoUTF8:[dictionary allValues] dictionary:dictionary];
    }
}


+(NSMutableDictionary *)convertDictionaryIntoUTF8:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary
{
    for (id value in valuesArray)
    {
        // if dictonary contains string values
        if ([value isKindOfClass:[NSString class]])
        {
            NSString * utf8String = [self stringDecodeFrombase64String:value];
            for (NSString * key in [dictionary allKeys])
            {
                if ([[dictionary objectForKey:key] isKindOfClass:[NSString class]])
                {
                    if ([[dictionary objectForKey:key] isEqualToString:value])
                    {
                        [dictionary setObject:utf8String forKey:key];
                    }
                }
            }
        }
        //if dictionary contains an array as value
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSArray * allKeyArray = [dictionary allKeys];
            NSString * arrayName = @"";
            for (NSString * key in allKeyArray)
            {
                if ([dictionary valueForKey:key] == value)
                {
                    arrayName = key;
                }
            }
            
            NSMutableArray * valueCopy = [value mutableCopy];
            for (int j = 0; j < valueCopy.count; j++)
            {
                id key = [valueCopy objectAtIndex:j];
                
                //if array contains dictionary as value
                if ([key isKindOfClass:[NSDictionary class]])
                {
                    [self convertIntoUTF8:[key allValues] dictionary:key];
                }
                
                //if array contains string values
                else if ([key isKindOfClass:[NSString class]])
                {
                    NSString * utf8String = [self stringDecodeFrombase64String:key];
                    for (int i = 0; i < valueCopy.count; i++)
                    {
                        if ([[valueCopy objectAtIndex:i] isEqualToString:key])
                        {
                            [valueCopy replaceObjectAtIndex:i withObject:utf8String];
                        }
                    }
                }
            }
            
            [dictionary setObject:valueCopy forKey:arrayName];
        }
        
        // if dictonary contains dictionary as value
        if ([value isKindOfClass:[NSDictionary class]])
        {
            [self convertIntoUTF8:[value allValues] dictionary:value];
        }
    }
    return dictionary;
}
+ (NSString *)base64StringEncodeFromString:(NSString *)string
{
    NSData * encodeData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [encodeData base64EncodedStringWithOptions:0];
    return base64String;
}

+ (NSString *)stringDecodeFrombase64String:(NSString *)base64String
{
    NSString * decodedString;
    if (base64String.length)
    {
        NSData * decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    }
    else
    {
        decodedString = base64String;
    }
    return [self returnStringAfterValidation:decodedString];
}

+ (NSString *)returnStringAfterValidation:(id)value
{
    if (![value isKindOfClass:[NSString class]])
    {
        return @"";
    }
    return value;
}
+(NSString *)changeTimeformat:(NSString*)time
{
    NSArray *items = [time componentsSeparatedByString:@":"];
    NSString *drtnDay=[items objectAtIndex:0];
    NSString *drtnHour=[items objectAtIndex:1];
    NSString *drtnMin=[items objectAtIndex:2];
    //    NSString *drtnSec=[items objectAtIndex:3];
    NSString *finalDrtn=[NSString stringWithFormat:@"%dd %dh %dm",[drtnDay intValue],[drtnHour intValue],[drtnMin intValue]];
    
    return finalDrtn;
}
+(NSAttributedString *)changeLineSpacing:(NSString*)str
{
    if ([Utility sharedInstance].isDeviceIpad)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10.0f;
        paragraphStyle.paragraphSpacing = 15.0f;
        CGFloat fontSize = 21;
        NSString *string = str;
        NSDictionary *ats = @{
                              NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize],
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        
        NSAttributedString *atStr = [[NSAttributedString alloc] initWithString:string attributes:ats];
        
        
        return  atStr;
    }
    else
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        paragraphStyle.paragraphSpacing = 10.0f;
        CGFloat fontSize = 17;
        NSString *string = str;
        NSDictionary *ats = @{
                              NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize],
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        
        NSAttributedString *atStr = [[NSAttributedString alloc] initWithString:string attributes:ats];
        
        
        return  atStr;
    }

    
}
@end
