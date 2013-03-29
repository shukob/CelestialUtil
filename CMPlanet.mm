
#import "CMPlanet.h"
#import "define.h"
#import "CMGeoscienceUtility.h"
@interface CMPlanet(){

}
@end

@implementation CMPlanet




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

-(double) E:(double) T{
    return E(T);
}

-(double) beta:(double)T{
    return 0;
}

-(double)declinationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate TimeZone:(NSTimeZone*)zone{
    double t = [CMGeoscienceUtility pastJulianYearOfDate:date inLocation:coordinate ofTimeZone:zone];
    double l = [self lambda:t];
    double b = [self beta:t];
    double e = [self E:t];
    double alpha, delta;
    [self setDelta:&delta andAlpha:&alpha usingLambda:l andBeta:b andEpsilon:e];
    return D2R(delta);
}

-(double)azimuthAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinate TimeZone:(NSTimeZone* )zone{
    double t = [CMGeoscienceUtility pastJulianYearOfDate:date inLocation:coordinate ofTimeZone:zone];//T(date);
    double l = [self lambda:t];
    double e = [self E:t];
    double b = [self beta:t];
    double al, del;
    [self setDelta:&del andAlpha:&al usingLambda:l andBeta:b andEpsilon:e];

    double t_ = [CMGeoscienceUtility siderealTimeOfDate:date inLocation:coordinate ofTimeZone:zone]-al;
    double a = [self azimuth:del phi:coordinate.latitude t:t_];
    return D2R(a);
}

-(double)lambda:(double)T{
    return 0;
}

@end
