
#import "CMSun.h"
#import "CMLocationUtility.h"
#import "CMCelestialUtility.h"
#import "define.h"

@implementation CMSun

#define SUM_LAMBDA_COEFF_NUM 20

static double lambdaCoeff1[SUM_LAMBDA_COEFF_NUM]={
    280.4603,
    0,
    0.0200,
    0.0048,
    0.0020,
    0.0018,
    0.0018,
    0.0015,
    0.0013,
    0.0008,
    0.0007,
    0.0007,
    0.0006,
    0.0005,
    0.0005,
    0.0004,
    0.0004,
    0.0004,
    0.0003,
    0.0003
};

static double lambdaCoeff2[SUM_LAMBDA_COEFF_NUM] = {
    0,
    0,
    355.05,
    234.95,
    247.1,
    297.8,
    251.3,
    343.2,
    81.4,
    132.5,
    153.3,
    206.8,
    29.8,
    207.4,
    291.2,
    234.9,
    157.3,
    21.1,
    352.5,
    329.7
};

static double lambdaCoeff3[SUM_LAMBDA_COEFF_NUM] = {
    360.00769,
    0,
    719.981,
    19.341,
    329.64,
    4452.67,
    0.20,
    450.37,
    225.18,
    659.29,
    90.38,
    30.35,
    337.18,
    1.50,
    22.81,
    315.56,
    299.30,
    720.02,
    1079.97,
    44.43
};

static double QCoeff1[] = {
    0,
    0.000091,
    0.000030,
    0.000013,
    0.000007,
    0.000007
};

static double QCoeff2[] = {
    0,
    265.1,
    90,
    27.8,
    254,
    156
};

static double QCoeff3[] = {
    0,
    719.98,
    0,
    4452.67,
    450.4,
    329.6
};

-(double)lambda:(double)T{
    return lambda(T);
}

static double lambda(double T){
    double res = lambdaCoeff1[0]+lambdaCoeff3[0]*T;

    double temp =(1.9146-0.00005*T)*SIN(357.538 + 359.991*T);
    res+=temp;
    for (int i = 2; i < SUM_LAMBDA_COEFF_NUM; ++i) {
        double a = lambdaCoeff1[i]*SIN(lambdaCoeff2[i]+lambdaCoeff3[i]*T);
        res+=a;
    }
    return res;
}

static double q(double T){
    double res = (0.007256 - 0.00000002*T)*SIN(267.54 + 359.991 *T);
    for (int i = 0; i < 6; ++i) {
        res+=QCoeff1[i]*SIN(QCoeff2[i] + QCoeff3[i]*T);
    }
    return res;
}

static double r(double T){
    return pow(10, q(T));
}

static double beta(double T){
    return 0;
}


-(double)beta:(double)T{
    return beta(T);
}


@end




