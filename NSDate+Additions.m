/*The MIT License
 
Copyright (c) 2013 skonb(Shunpei Kobayashi)
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE*/
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
