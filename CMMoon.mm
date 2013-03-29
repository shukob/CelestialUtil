/*The MIT License
 
Copyright (c) 2013 skonb(Shunpei Kobayashi)
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE*/
#import "CMMoon.h"
#import "define.h"
#import <cmath>
#define LAMBDA_COEFF_NUM 64

static double lambdaCoeff1[LAMBDA_COEFF_NUM] = {
    218.3161,
    6.2887,
    1.2740,
    0.6583,
    0.2136,
    0.1856,
    0.1143,
    0.0588,
    0.0572,
    0.0533,
    0.0459,
    0.0410,
    0.0348,
    0.0305,
    0.0153,
    0.0125,
    0.0110,
    0.0107,
    0.0100,
    0.0085,
    0.0079,
    0.0068,
    0.0052,
    0.0050,
    0.0048,
    0.0040,
    0.0040,
    0.0040,
    0.0039,
    0.0037,
    0.0027,
    0.0026,
    0.0024,
    0.0024,
    0.0022,
    0.0021,
    0.0021,
    0.0021,
    0.0020,
    0.0018,
    0.0016,
    0.0012,
    0.0011,
    0.0009,
    0.0008,
    0.0008,
    0.0007,
    0.0007,
    0.0007,
    0.0006,
    0.0005,
    0.0005,
    0.0005,
    0.0005,
    0.0004,
    0.0004,
    0.0004,
    0.0004,
    0.0003,
    0.0003,
    0.0003,
    0.0003,
    0.0003,
    0.0003
};


double lambdaCoeff2[LAMBDA_COEFF_NUM]={
    0,
    134.961,
    100.738,
    235.700,
    269.926,
    177.525,
    6.546,
    214.22,
    103.21,
    10.66,
    238.18,
    137.43,
    117.84,
    312.49,
    130.84,
    141.51,
    231.59,
    336.44,
    44.89,
    201.5,
    278.2,
    53.2,
    197.2,
    295.4,
    235.0,
    13.2,
    145.6,
    119.5,
    111.3,
    349.1,
    272.5,
    107.2,
    211.9,
    252.8,
    240.6,
    87.5,
    175.1,
    105.6,
    55.0,
    4.1,
    242.2,
    339.0,
    276.5,
    218.0,
    188,
    204,
    140,
    275,
    216,
    128,
    247,
    181,
    114,
    332,
    313,
    278,
    71,
    20,
    83,
    66,
    147,
    311,
    161,
    280
};

double lambdaCoeff3[LAMBDA_COEFF_NUM]={
    4812.67881,
    4771.9886,
    4133.3536,
    8905.3422,
    9543.9773,
    359.9905,
    9664.0404,
    638.635,
    3773.363,
    13677.331,
    8545.352,
    4411.998,
    4452.671,
    5131.979,
    758.698,
    14436.029,
    4892.052,
    13028.696,
    14315.966,
    8266.71,
    4493.34,
    9265.33,
    319.32,
    4812.66,
    19.34,
    13317.34,
    18449.32,
    1.33,
    17810.68,
    5410.62,
    9883.99,
    13797.39,
    988.63,
    9224.66,
    8185.36,
    9903.97,
    719.98,
    3413.37,
    19.34,
    4013.29,
    18569.38,
    12678.71,
    19208.02,
    8586.0,
    14037.3,
    7906.7,
    4052.0,
    4853.3,
    278.6,
    1118.7,
    22582.7,
    19088.0,
    17450.7,
    5091.3,
    398.7,
    120.1,
    9584.7,
    720.0,
    3814.0,
    3494.7,
    18089.3,
    5492.0,
    40.7,
    23221.3
};

double ACoeff1[]={
    0.0040,
    0.0020,
    0.0006,
    0.0006
};

double ACoeff2[]={
    119.5,
    55.0,
    71,
    54,
};

double ACoeff3[]={
    1.33,
    19.34,
    0.2,
    19.3
};

#define BETA_COEFF_NUM 47

double betaCoeff1[BETA_COEFF_NUM]={
    5.1282,
    0.2806,
    0.2777,
    0.1732,
    0.0554,
    0.0463,
    0.0326,
    0.0172,
    0.0093,
    0.0088,
    0.0082,
    0.0043,
    0.0042,
    0.0034,
    0.0025,
    0.0022,
    0.0021,
    0.0019,
    0.0018,
    0.0018,
    0.0017,
    0.0016,
    0.0015,
    0.0015,
    0.0014,
    0.0013,
    0.0013,
    0.0012,
    0.0012,
    0.0011,
    0.0010,
    0.0008,
    0.0008,
    0.0007,
    0.0006,
    0.0006,
    0.0005,
    0.0005,
    0.0004,
    0.0004,
    0.0004,
    0.0004,
    0.0004,
    0.0003,
    0.0003,
    0.0003,
    0.0003
};

double betaCoeff2[BETA_COEFF_NUM]={
    93.273,
    228.235,
    138.311,
    142.427,
    194.01,
    172.55,
    328.96,
    3.18,
    277.4,
    176.7,
    144.9,
    307.6,
    103.9,
    319.9,
    196.5,
    331.4,
    170.1,
    230.7,
    243.3,
    270.8,
    99.8,
    135.7,
    211.1,
    45.8,
    219.2,
    95.8,
    155.4,
    38.4,
    148.2,
    138.3,
    18.0,
    70,
    326,
    294,
    224,
    52,
    280,
    239,
    311,
    238,
    81,
    13,
    147,
    205,
    107,
    146,
    234
};

double betaCoeff3[BETA_COEFF_NUM]={
    4832.0202,
    9604.0088,
    60.0316,
    4073.3220,
    8965.374,
    698.667,
    13737.362,
    14375.997,
    8845.31,
    4711.96,
    3713.33,
    5470.66,
    18509.35,
    4433.31,
    8605.38,
    13377.37,
    1058.66,
    9244.02,
    8206.68,
    5192.01,
    14496.06,
    420.02,
    9284.69,
    9964.00,
    299.96,
    4472.03,
    379.35,
    4812.68,
    4851.36,
    19147.99,
    12978.66,
    17870.7,
    9724.1,
    13098.7,
    5590.7,
    13617.3,
    8485.3,
    4193.4,
    9483.9,
    23281.3,
    10242.6,
    9325.4,
    14097.4,
    22642.7,
    18149.4,
    3353.3,
    19268.0
};

double BCoeff1[]={
    0.0267,
    0.0043,
    0.0040,
    0.0026,
    0.0005
};

double BCoeff2[]={
    234.95,
    322.1,
    119.5,
    55.0,
    307,
};

double BCoeff3[] = {
    19.341,
    19.36,
    1.33,
    19.34,
    19.4
};


double PICoeff1[] = {
    0.9507,
    0.0518,
    0.0095,
    0.0078,
    0.0028,
    0.0009,
    0.0005,
    0.0004,
    0.0003
};

double PICoeff2[]={
    90,
    224.98,
    190.7,
    325.7,
    0,
    100,
    329,
    194,
    227
};

double PICoeff3[]= {
    0,
    4771,989,
    4133.25,
    8905.34,
    9542.98,
    13677.3,
    8545.4,
    3773.4,
    4412.0
};

double A(double T){
    double res = 0;
    for (int i = 0; i < 4 ; ++i) {
        res+=ACoeff1[i]*SIN(ACoeff2[i]+ACoeff3[i]*T);
    }
    return res;
}


static double lambda(double T){
    double res=lambdaCoeff1[0]+lambdaCoeff3[0]*T;
    res+=lambdaCoeff1[1]*SIN(lambdaCoeff2[1] + lambdaCoeff3[1]*T + A(T));
    for (int i = 2; i < LAMBDA_COEFF_NUM; ++i) {
        res+=lambdaCoeff1[i]*SIN(lambdaCoeff2[i] + lambdaCoeff3[i]*T);
    }
    return res;
}

static double B(double T){
    double res = 0;
    for (int i = 0; i < 5 ; ++i) {
        res+=BCoeff1[i]*SIN(BCoeff2[i]+BCoeff3[i]*T);
    }
    return res;
    
}

static double beta(double T){
    double res = 0;
    res+=betaCoeff1[0]*SIN(betaCoeff2[0]+betaCoeff3[0]*T + B(T));
    for (int i = 1 ; i < BETA_COEFF_NUM; ++i) {
        res+=betaCoeff1[i]*SIN(betaCoeff2[i]+betaCoeff3[i]*T);
    }
    return res;
}

static double PI(double T){
    double res = 0;
    for (int i =0; i < 9 ; ++i) {
        res+=PICoeff1[i]*SIN(PICoeff2[i]+PICoeff3[i]*T);
    }
    return res;
}




@implementation CMMoon

#define VELOCITY_DIFFERENCE_BETWEEN_SUN_AND_MOON 12.1818

-(double)lambda:(double)T{
    return lambda(T);
}

-(double)beta:(double)T{
    return beta(T);
}

@end


