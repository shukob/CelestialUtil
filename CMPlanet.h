#import "CMBasicSingleton.h"
#import <CoreLocation/CoreLocation.h>
@interface CMPlanet : CMBasicSingleton{
    
    
    
}
-(double)azimuthAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinte TimeZone:(NSTimeZone*)zone;

-(double)declinationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinte TimeZone:(NSTimeZone*)zone;

-(double) normalizeRadian:(double) angle;

-(double) moveToSameQuadrant:(double)target reference:(double) reference;

//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
-(double) alpha:(double)lam e:(double)e;


//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
-(double) delta:(double)lam e:(double)e;


-(double) azimuth:(double)del phi:(double) phi t:( double) t;

-(double) E:(double) T;

-(double)lambda:(double)T;

-(double)beta:(double)T;

-(void)setDelta:(double*)delta andAlpha:(double*)alpha usingLambda:(double)lambda andBeta:(double)beta andEpsilon:(double)epsilon;

@end

