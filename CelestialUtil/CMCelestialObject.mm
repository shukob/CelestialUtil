/*The MIT License
 
Copyright (c) 2013 skonb(Shunpei Kobayashi)
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE*/
#import "CMCelestialObject.h"
#import "define.h"
#import "CMCelestialUtility.h"
@interface CMCelestialObject(){

}
@end

@implementation CMCelestialObject




static double normalizeRadian(double angle){
    double temp = angle/(2.0*M_PI);
    long tempLong = temp;
    angle-=tempLong*2.0*M_PI;
    while (angle<0) {
        angle+=M_PI*2.;
    }
    while (angle>M_PI*2.) {
        angle-=M_PI*2.;
    }
    return angle;
}

//angles are in radian
static double moveToSameQuadrant(double target, double reference){
    target = normalizeRadian(target);
    reference = normalizeRadian(reference);
    if (0<=reference && reference <M_PI_2) {
        if (M_PI <= target && target < M_PI + M_PI_2) {
            target -=M_PI;
        }
    }else if(M_PI_2 <= reference && reference < M_PI){
        if(M_PI +M_PI_2 < target){
            target -=M_PI;
        }
    }else if(M_PI <=reference && reference <M_PI+M_PI_2){
        if (0 <=target && target < M_PI_2) {
            target += M_PI;
        }
    }else if(M_PI+M_PI_2 <=reference ){
        if (M_PI_2 <= target && target < M_PI) {
            target+=  M_PI;
        }
    }
    return target;
}

//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
double alpha(double lam, double e){
    double tanAlpha = TAN(lam)*COS(e);
    double res = atan(tanAlpha);
    res = moveToSameQuadrant(res, D2R(lam));
    return R2D(res);
}

//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
static double delta(double lam, double e){
    double sinDelta = SIN(lam)*SIN(e);
    return R2D(asin(sinDelta));
}

static double azimuth(double del, double phi, double t){
    double numerator = (-COS(del)*SIN(t));
    double denominator = (SIN(del)*COS(phi)-COS(del)*SIN(phi)*COS(t));
    double A_ = atan(numerator/denominator);
    NSLog(@"A:%lf, num:%lf, den:%lf", A_, numerator, denominator);
    if (denominator<0) {
        A_+=M_PI;
    }else if(denominator==0){
        if (SIN(t)>0) {
            A_=-M_PI_2;
        }else if(SIN(t)<0){
            A_=M_PI_2;
        }
    }
    return R2D(A_);
}

static double elevation(double del, double phi, double t){
    return R2D(asin(SIN(del)*SIN(phi) + COS(del) * COS(phi) * COS(t)));
}

//angles are in degree
static void setDeltaAndAlpha(double lam, double bet, double e, double&delta, double&alpha){
    double U = COS(bet)*COS(lam);
    double V = -SIN(bet)*SIN(e) + COS(bet)*SIN(lam)*COS(e);
    double W = SIN(bet)*COS(e) + COS(bet)*SIN(lam)*SIN(e);
    double alpha_ = atan(V/U);
    double delta_ = atan(W/sqrt(U*U+V*V));
    if (U<0) {
        alpha_+=M_PI;
    }
    alpha = R2D(alpha_);
    delta = R2D(delta_);
}


static double E(double T){
    return 23.439291 - 0.000130042*T;
}


-(void)setDelta:(double *)delta andAlpha:(double *)alpha usingLambda:(double)lambda andBeta:(double)beta andEpsilon:(double)epsilon{
    setDeltaAndAlpha(lambda, beta, epsilon, *delta, *alpha);
}


-(double) normalizeRadian:(double) angle{
    return normalizeRadian(angle);
}

-(double) moveToSameQuadrant:(double)target reference:(double) reference{
    return moveToSameQuadrant(target, reference);
}

//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
-(double) alpha:(double)lam e:(double)e{
    return alpha(lam, e);
}

//This method assumes angles to be in 0 <= angle < 360
//This method returns angles in degrees
-(double) delta:(double)lam e:(double)e{
    return delta(lam, e);
}


-(double) azimuth:(double)del phi:(double) phi t:( double) t{
    return azimuth(del, phi, t);
}

-(double) elevation:(double)del phi:(double)phi t:(double)t{
    return elevation(del, phi, t);
}

-(double) E:(double) T{
    return E(T);
}

-(double) beta:(double)T{
    return 0;
}

-(double)declinationAtDate:(NSDate*)date{
    double t = [CMCelestialUtility pastJulianYearOfDate:date];
    double l = [self lambda:t];
    double b = [self beta:t];
    double e = [self E:t];
    double alpha, delta;
    [self setDelta:&delta andAlpha:&alpha usingLambda:l andBeta:b andEpsilon:e];
    return D2R(delta);
}

-(double)azimuthAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate{
    double t = [CMCelestialUtility pastJulianYearOfDate:date];//T(date);
    double l = [self lambda:t];
    double e = [self E:t];
    double b = [self beta:t];
    double al, del;
    [self setDelta:&del andAlpha:&al usingLambda:l andBeta:b andEpsilon:e];
    double t_ = [CMCelestialUtility siderealTimeOfDate:date inLocation:coordinate]-al;
    double a = [self azimuth:del phi:coordinate.latitude t:t_];
    return D2R(a);
}

-(double)lambda:(double)T{
    return 0;
}

-(double)elevationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate{
    double t = [CMCelestialUtility pastJulianYearOfDate:date];//T(date);
    double l = [self lambda:t];
    double e = [self E:t];
    double b = [self beta:t];
    double al, del;
    [self setDelta:&del andAlpha:&al usingLambda:l andBeta:b andEpsilon:e];
    double t_ = [CMCelestialUtility siderealTimeOfDate:date inLocation:coordinate]-al;
    double a = [self elevation:del phi:coordinate.latitude t:t_];
    return D2R(a);
}

-(double)hourAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate{
    double t = [CMCelestialUtility pastJulianYearOfDate:date];//T(date);
    double l = [self lambda:t];
    double e = [self E:t];
    double b = [self beta:t];
    double al, del;
    [self setDelta:&del andAlpha:&al usingLambda:l andBeta:b andEpsilon:e];
    double t_ = [CMCelestialUtility siderealTimeOfDate:date inLocation:coordinate]-al;
    return D2R(t_);
}

//elevation must be in degree
-(double)atmosphicReflactionForElevation:(double)elevation{
    return D2R(0.0167 / TAN(elevation + 8.6 / (elevation + 4.4)));
}

-(double)apparentElevationAtDate:(NSDate *)date inLocation:(CLLocationCoordinate2D)coordinate{
    double elevation = [self elevationAtDate:date inLocation:coordinate];
    return elevation + [self atmosphicReflactionForElevation:elevation] - [self equatorialHorizontalParallaxAtDate:date inLocation:coordinate];
}

-(double)equatorialHorizontalParallaxAtDate:(NSDate *)date{
    double t = [CMCelestialUtility pastJulianYearOfDate:date];//T(date);
    return [self equatorialHorizontalParallax:t];
}

-(double)geocentricDistanceAtDate:(NSDate *)date{
    double t = [CMCelestialUtility pastJulianYearOfDate:date];//T(date);
    return [self geocentricDistance:t];
}
-(double)geocentricDistance:(double)T{
    return D2R(0.0024428)/[self equatorialHorizontalParallax:T];
}

@end
