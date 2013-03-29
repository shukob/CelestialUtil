#import "NSDate+Additions.h"
#import "CMTimeZone.h"

@implementation NSDate (Additions)
-(NSDate*)beginningOfDate{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init]autorelease];
    fmt.timeZone = [CMTimeZone defaultTimeZone];
    fmt.dateFormat = @"y/M/d H:m:s";
    
    
    NSInteger y = [components year];
    NSInteger M = [components month];
    NSInteger D = [components day];
    NSDate *beginingOfDay = [fmt dateFromString:[NSString stringWithFormat:@"%d/%d/%d 0:0:0", y, M, D]];
    return beginingOfDay;
}

-(NSTimeInterval)timeIntervalSinceBeginningOfYear{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init]autorelease];
    fmt.dateFormat = @"y/M/d H:m:s";
    fmt.timeZone = [CMTimeZone defaultTimeZone];
    NSInteger y = [components year];
    NSDate *firstDayOfYear = [fmt dateFromString:[NSString stringWithFormat:@"%d/1/1 0:0:0", y]];
    return [self timeIntervalSinceDate:firstDayOfYear];

}

-(NSTimeInterval)timeIntervalSinceBeginningOfDay{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init]autorelease];
    fmt.timeZone = [CMTimeZone defaultTimeZone];
    fmt.dateFormat = @"y/M/d H:m:s";
    NSInteger y = [components year];
    NSDate *beginningOfDay = [fmt dateFromString:[NSString stringWithFormat:@"%d/%d/%d 0:0:0", y, components.month, components.day]];
    return [self timeIntervalSinceDate:beginningOfDay];
}

-(NSDate*)nextZeroSecondDate{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:self];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init]autorelease];
    fmt.timeZone = [CMTimeZone defaultTimeZone];
    fmt.dateFormat = @"y/M/d H:m:s";
    if (components.second==0) {
        return [NSDate dateWithTimeInterval:0 sinceDate:self];
    }else{
        NSDate *res = [fmt dateFromString:[NSString stringWithFormat:@"%d/%d/%d %d:%d:0", components.year,components.month, components.day,components.hour, components.minute]];
        return [res dateByAddingTimeInterval:60];
    }
}
-(NSDate*)beginningOfDateInTimeZone:(NSTimeZone*)timeZone{
    NSCalendar *cal = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    [cal setTimeZone:timeZone];
    NSDateComponents *components = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:self];
    [components setTimeZone:timeZone];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init]autorelease];
    fmt.timeZone = [CMTimeZone defaultTimeZone];
    fmt.dateFormat = @"y/M/d H:m:s Z";
    NSInteger y = [components year];
    NSInteger M = [components month];
    NSInteger D = [components day];
    double secondsFromGMT = [timeZone secondsFromGMT];
    double absSecondsFromGMT = abs(secondsFromGMT);
    NSInteger hoursFromGMT = absSecondsFromGMT/60/60;
    NSInteger minutesFromGMT = (absSecondsFromGMT-hoursFromGMT*60*60)/60;
    NSString *sign = secondsFromGMT>0 ? @"+" : @"-";
    NSString *timeZoneDescription = [NSString stringWithFormat:@"%@%02d%02d", sign, hoursFromGMT, minutesFromGMT];
    NSDate *beginningOfDay = [fmt dateFromString:[NSString stringWithFormat:@"%d/%d/%d 0:0:0 %@", y, M, D, timeZoneDescription]];
    return beginningOfDay;
}

@end
