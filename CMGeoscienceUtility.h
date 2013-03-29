#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CMGeoscienceUtility : NSObject
+(double)fractionalYearAtDate:(NSDate*)date;
+(double)azimuthAngleAtCoordinate:(CLLocationCoordinate2D)coordinate atDate:(NSDate*)date;
+(double)equationOfTimeAtDate:(NSDate*)date;
+(double)pastJulianYearOfDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate ofTimeZone:(NSTimeZone*)timeZone;
+(double)siderealTimeOfDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate ofTimeZone:(NSTimeZone*)timeZone;
+(void)test;
@end


