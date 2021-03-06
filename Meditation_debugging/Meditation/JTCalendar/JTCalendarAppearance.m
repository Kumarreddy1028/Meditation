//
//  JTCalendarAppearance.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarAppearance.h"

@implementation JTCalendarAppearance

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
        
    [self setDefaultValues];
    
    return self;
}

- (void)setDefaultValues
{
    self.isWeekMode = NO;
    
    self.weekDayFormat = JTCalendarWeekDayFormatShort;
    
    self.ratioContentMenu = 2.;
    self.dayCircleRatio = 1.;
    self.dayDotRatio = 1. / 9.;
    
    self.menuMonthTextFont = [UIFont fontWithName:@"ProximaNova-Regular" size:14.0];
    self.weekDayTextFont = [UIFont fontWithName:@"ProximaNova-Regular" size:13.0];
    self.dayTextFont = [UIFont fontWithName:@"ProximaNova-Regular" size:15.0];
    
    self.menuMonthTextColor = [UIColor blackColor];
   self.weekDayTextColor = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
    
  //  [self setDayDotColorForAll:[UIColor colorWithRed:43./256. green:88./256. blue:134./256. alpha:1.]];
    
    [self setDayTextColorForAll:[UIColor colorWithRed:60/256. green:65/256. blue:92/256. alpha:1.]];
    
    //self.dayTextColorOtherMonth = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
    self.dayTextColorOtherMonth = [UIColor clearColor];
    
    self.dayCircleColorSelected = [UIColor clearColor];
    self.dayTextColorSelected = [UIColor colorWithRed:247/256. green:173/256. blue:60/256. alpha:1];
    self.dayDotColorSelected = [UIColor whiteColor];
    
    self.dayCircleColorSelectedOtherMonth = self.dayCircleColorSelected;
    self.dayTextColorSelectedOtherMonth = self.dayTextColorSelected;
    self.dayDotColorSelectedOtherMonth = self.dayDotColorSelected;
    
    self.dayCircleColorToday = [UIColor colorWithRed:240/256. green:240/256. blue:240/256. alpha:1];
    self.dayTextColorToday = [UIColor colorWithRed:60/256. green:65/256. blue:92/256. alpha:1];
    self.dayDotColorToday = [UIColor whiteColor];
    
    self.dayCircleColorTodayOtherMonth = self.dayCircleColorToday;
//    self.dayTextColorTodayOtherMonth = self.dayTextColorToday;
//    self.dayDotColorTodayOtherMonth = self.dayDotColorToday;
    self.dayTextColorTodayOtherMonth = [UIColor whiteColor];
    self.dayDotColorTodayOtherMonth = [UIColor whiteColor];
}

- (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

- (void)setDayDotColorForAll:(UIColor *)dotColor
{
    self.dayDotColor = dotColor;
    self.dayDotColorSelected = dotColor;
    
    self.dayDotColorOtherMonth = dotColor;
    self.dayDotColorSelectedOtherMonth = dotColor;
    
    self.dayDotColorToday = dotColor;
    self.dayDotColorTodayOtherMonth = dotColor;
}

- (void)setDayTextColorForAll:(UIColor *)textColor
{
    self.dayTextColor = textColor;
    self.dayTextColorSelected = textColor;
    
    self.dayTextColorOtherMonth = textColor;
    self.dayTextColorSelectedOtherMonth = textColor;
    
    self.dayTextColorToday = textColor;
    self.dayTextColorTodayOtherMonth = textColor;
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
