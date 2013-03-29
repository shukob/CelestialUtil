/*The MIT License
 
Copyright (c) 2013 skonb(Shunpei Kobayashi)
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE*/
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

