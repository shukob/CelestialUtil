/*The MIT License
 
Copyright (c) 2013 skonb(Shunpei Kobayashi)
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE*/
#import "CMCelestialUtility.h"
#import "NSDate+Additions.h"
#import "define.h"
@implementation CMCelestialUtility


+(double)fractionalYearAtDate:(NSDate*)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:date];
    NSInteger year = [components year];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init] autorelease];
    fmt.dateFormat = @"y/M/d H:m:s";
    NSDate *firstDayOfTheYear = [fmt dateFromString:[NSString stringWithFormat:@"%d/1/1 0:0:0", year]];
    NSLog(@"first day of the year:%@", firstDayOfTheYear);
    NSTimeInterval intervalInSeconds = [date timeIntervalSinceDate:firstDayOfTheYear];
    double fraction = intervalInSeconds / (365.25 * 24.0 * 60.0 * 60.0);
    NSLog(@"fraction:%lf", fraction);
    return  floor(fraction) * 360.0;
}

+(double)decrenationOfTheSunAtDate:(NSDate*)date{
    double g = [self fractionalYearAtDate:date]/180.0*M_PI;
    return 0.396372-22.91327*cos(g)+4.02543*sin(g)-0.387205*cos(2.0*g)+0.051967*sin(2.0*g)-0.154527*cos(3.0*g) + 0.084798*sin(3.0*g);
}

+(double)timeCorrectionForSolarAngle:(NSDate*)date{
    double g = [self fractionalYearAtDate:date]/180.0*M_PI;
    return 0.004297+0.107029*cos(g)-1.837877*sin(g)-0.837378*cos(2.0*g)-2.340475*sin(2.0*g);
}

+(double)solarHourAngleAtCoordinate:(CLLocationCoordinate2D)coordinate atDate:(NSDate*)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init] autorelease];
    fmt.dateFormat = @"y/M/d H:m:s";
    NSDate *beginningOfTheDay = [fmt dateFromString:[NSString stringWithFormat:@"%d/%d/%d 0:0:0", year, month, day]];
    NSTimeInterval intervalInSeconds = [date timeIntervalSinceDate:beginningOfTheDay];
    NSInteger hoursFromBeginning = intervalInSeconds / 60.0 /60.0;
    return (hoursFromBeginning - 12.0) * 15.0 + coordinate.longitude + [self timeCorrectionForSolarAngle:date];
}

+(double)sunZenithAngleAtCoordinate:(CLLocationCoordinate2D)coordinate atDate:(NSDate*)date{
    double D = [self decrenationOfTheSunAtDate:date];
    double SHA = [self solarHourAngleAtCoordinate:coordinate atDate:date];
    double lat = coordinate.latitude/180.0*M_PI;
    double cosSZA = sin(lat)*sin(D)+cos(lat)*cos(D)*cos(SHA);
    NSLog(@"zenith angle:%lf", acos(cosSZA));
    return acos(cosSZA);
}

+(double)azimuthAngleAtCoordinate:(CLLocationCoordinate2D)coordinate atDate:(NSDate*)date{
    double SZA = [self sunZenithAngleAtCoordinate:coordinate atDate:date];
    double D = [self decrenationOfTheSunAtDate:date];
    double lat = coordinate.latitude/180.0*M_PI;
    double cosAZ = (sin(D)-sin(lat)*cos(SZA))/(cos(lat)*sin(SZA));
    NSLog(@"azimuth angle:%lf", acos(cosAZ));
    return acos(cosAZ);
}

+(double)equationOfTimeAtDate:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:date];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init]autorelease];
    fmt.dateFormat = @"y/M/d H:m:s";
    NSInteger y = [components year];
    NSDate *firstDayOfYear = [fmt dateFromString:[NSString stringWithFormat:@"%d/1/1 0:0:0", y]];
    NSInteger yday = [date timeIntervalSinceDate:firstDayOfYear]/60.0/60.0/24.0;
    double B = 2*M_PI*yday/365.25;
    double et = (0.000075 + 0.001868 * cos(B)  -0.032077*sin(B) 
                 -0.014615 * cos(2*B) -0.040849 * sin(2*B) ) * 12 / M_PI;
    return et;
}

static double deltaT(double T){
    return 80.84308/(1+0.2605601*exp(-4.42379*T))-0.311;
}

+(double)deltaTForYear:(NSInteger)year{
    return 51 + (year-1981) * 0.6;
}

+(double)pastJulianYearOfDate:(NSDate *)date inLocation:(CLLocationCoordinate2D)coordinate ofTimeZone:(NSTimeZone *)timeZone{
    NSCalendar *cal = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    [cal setTimeZone:timeZone];
    NSDateComponents *components = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:date];
    //The calculation formula is that if time is (2000 + y) / m / d h:m:s +0900
    //then K'(Julian year from 2000/1/1) is 365y + 30m + d - 33.875 + [3(m + 1)/5] + [y/4] where [] is Gauss function.
    //For m = 1, 2, we need y-=1 and m+=12 i.e. m=1 -> m=13, m=2 -> m=14 in previous year.
    //Be careful that it uses JST for time representation.
    
    
    //Calculate using JST(+0900)
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:9 * 60 * 60]];
    double y = components.year - 2000;
    double m = components.month;
    double d = components.day;
    double I = [timeZone secondsFromGMT]/60/60;
    if (m<=2) {
        m+=12;
        y-=1;
    }
    double k_ = 365.0*y + 30 * m + d - 33.5 - I / 24.0 + floor(3.0 * (m + 1) / 5.0) + floor(y/4.0);
    double g = components.hour;
    
    double t =(k_ + g/24.0 + [self deltaTForYear:components.year]/86400)/365.25;
    return t;
}


static double theta0(double T, double I, double lambda){
    return  100.4606  + 360.007700536 * T + 0.00000003879 * T * T - 15. * I + lambda;
}

+(double)siderealTimeOfDate:(NSDate *)date inLocation:(CLLocationCoordinate2D)coordinate ofTimeZone:(NSTimeZone *)timeZone{
    NSDate *beginingOfDay = [date beginningOfDateInTimeZone:timeZone];
    double t0 = [self pastJulianYearOfDate:beginingOfDay inLocation:coordinate ofTimeZone:timeZone];
    
    double I = [timeZone secondsFromGMT]/60/60;
    double theta0_ = theta0(t0, I, coordinate.longitude);
    double theta = theta0_ ;
    
    NSTimeInterval timeIntervalSinceBeginningOfDay = [date timeIntervalSinceDate:beginingOfDay];
    theta += 360.9856474 * timeIntervalSinceBeginningOfDay/60./60./24.;
    return theta;
}

static double E(double T){
    return 23.439291 - 0.000130042*T;
}


+(void)test{
    NSDateFormatter *fmt = [[[NSDateFormatter alloc]init]autorelease];
    fmt.dateFormat = @"y/M/d H:m:s Z";
    NSDate *targetDate = [fmt dateFromString:@"2000/8/20 0:0:0 -0900"];
    double sidereal = [CMCelestialUtility siderealTimeOfDate:targetDate inLocation:CLLocationCoordinate2DMake(64.8167, -147.8667) ofTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-60*60*9]];
    long temp = sidereal/360;
    sidereal -= temp*360;
    NSLog(@"%lf", sidereal);
    NSLog(@"theta0: %lf", theta0(0.63484121, -9, -147.8667));
}


@end


