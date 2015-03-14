/*The MIT License
 
Copyright (c) 2013 skonb(Shunpei Kobayashi)
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE*/

#import <CoreLocation/CoreLocation.h>
@interface CMCelestialObject : NSObject{
    
    
    
}

//returns in 0 <= theta < 2π for any radian value
-(double) normalizeRadian:(double) angle;


-(double) moveToSameQuadrant:(double)target reference:(double) reference;

//Returns in radian
-(double)azimuthAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate ;

//Returns in radian
-(double)declinationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate ;

//Returns in radian
-(double)elevationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate ;

//Returns in radian
-(double)hourAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate ;

//Returns in radian
-(double)equatorialHorizontalParallaxAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate;

//Returns in radian
-(double)equatorialHorizontalParallax:(double)T;

//Returns in radian
-(double)apparentElevationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate ;

//Returns in AU
-(double)geocentricDistanceAtDate:(NSDate*)date;

//Returns in AU
-(double)geocentricDistance:(double)T;

//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
-(double) alpha:(double)lam e:(double)e;

//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
-(double) delta:(double)lam e:(double)e;

//Returns in degree 
-(double) azimuth:(double)del phi:(double) phi t:( double) t;

//Returns in degree
-(double) E:(double) T;

//Returns in degree
-(double)lambda:(double)T;

//Returns in degree 
-(double)beta:(double)T;

//Sets in degree
-(void)setDelta:(double*)delta andAlpha:(double*)alpha usingLambda:(double)lambda andBeta:(double)beta andEpsilon:(double)epsilon;



@end

