#import <Foundation/Foundation.h>

@interface NSDate (Additions)
-(NSDate*)beginningOfDate;
-(NSTimeInterval)timeIntervalSinceBeginningOfYear;
-(NSTimeInterval)timeIntervalSinceBeginningOfDay;
-(NSDate*)nextZeroSecondDate;
-(NSDate*)beginningOfDateInTimeZone:(NSTimeZone*)timeZone;
@end
