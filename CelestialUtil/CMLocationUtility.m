/*The MIT License
 
Copyright (c) 2013 skonb(Shunpei Kobayashi)
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE*/

#import "CMLocationUtility.h"
#import <math.h>

double radianExpression(CLLocationDegrees degree){
    return degree * M_PI /180.0;
}

//static double r = 6378137;

@implementation CMLocationUtility


+(CLLocationDegrees)angleFromCoordinate2:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to{
    double lat1 = radianExpression(from.latitude);
    double lat2 = radianExpression(to.latitude);
    double lon1 = radianExpression(from.longitude);
    double lon2 = radianExpression(to.longitude);
    double dlon = lon2 - lon1;
//    double dlat = lat2 - lat1;
    
//    double alpha = sin(dlon);
//    double beta = cos(lat1) * tan(lat2)  - sin(lat1) * cos(dlon);
//    double phi = M_PI_2 - atan2(beta, alpha);
//    return phi;
//    
    double y =sin(dlon) * cos(lat2);
    double x = cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(dlon);
    double theta = atan2(y, x);
    return theta;
}


+(CLLocationDegrees)angleFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to{
    NSLog(@"(%lf, %lf) - > (%lf, %lf)", from.latitude, from.longitude, to.latitude, to.longitude);
    double phi1 = radianExpression(from.latitude);
    double phi2 = radianExpression(to.latitude);
    double L1 = radianExpression(from.longitude);
    double L2 = radianExpression(to.longitude);
    double L = L2 - L1;
    double lambda = L;
    double previous_lambda = 0;
//    static const double a = 6378137;
//    static const double b = 6356752.31414036;
    static const  double _1_f = 298.257222101;
    static const double f = 1./_1_f;
    double U1 = atan((1. - f)*tan(phi1));
    double U2 = atan((1. - f)*tan(phi2));
    double cos_alpha_squared = 0;
    double sin_sigma = 0;
    double cos_sigma = 0;
    double cos_2_sigma_m  = 0;
    double sigma = 0;
    for (; ; ) {
        previous_lambda = lambda;
        NSLog(@"lambda:%lf", lambda);
        sin_sigma = sqrt(pow((cos(U2)*sin(lambda)), 2.) + pow((cos(U1)*sin(U2) - sin(U1)*cos(U2)*cos(lambda)), 2.));
        cos_sigma = sin(U1)*sin(U2) + cos(U1) * cos(U2) * cos(lambda);
        sigma = atan2(sin_sigma, cos_sigma);
        double sin_alpha = cos(U1)*cos(U2)*sin(lambda) / sin_sigma;
        cos_alpha_squared = 1. - sin_alpha * sin_alpha;
        cos_2_sigma_m = cos_sigma - 2. * sin(U1) * sin(U2) / cos_alpha_squared;
        double C = f / 16. * cos_alpha_squared * (4. + (4.-3.*cos_alpha_squared)*f);
        lambda = L + (1. - C) * f * sin_alpha * (sigma + C * sin_sigma * (cos_2_sigma_m + C * cos_sigma * (-1. + 2. * cos_2_sigma_m * cos_2_sigma_m)));
        if (fabs(lambda - previous_lambda) < 1.e-12) {
            break;
        }
    }
    
//    double u_squrared = cos_alpha_squared * (a * a - b* b)/b*b;
//    double A = 1 + u_squrared / 16384. * (4096. + u_squrared * (-768. + u_squrared * (320. - 175. * u_squrared)));
//    double B = u_squrared / 1024. * (256. + u_squrared * ( - 128. + u_squrared * (74. - 47. * u_squrared)));
//    double delta_sigma = B * sin_sigma * (cos_2_sigma_m + 1. / 4. * B * (cos_sigma * (-1. + 2. * cos_2_sigma_m*cos_2_sigma_m) - 1./6. * B * cos_2_sigma_m * (-3. + 4. * sin_sigma * sin_sigma) * (-3. + 4. * cos_2_sigma_m * cos_2_sigma_m)));
//    double s = b * A * (sigma - delta_sigma);
    double alpha1 = atan2(cos(U2)*sin(lambda) , (cos(U1)*sin(U2)-sin(U1)*cos(U2)*cos(lambda)));
    double alpha2 = atan2(cos(U1)*sin(lambda) , (-sin(U1)*cos(U2) + cos(U1)*sin(U2)*cos(lambda)));
    NSLog(@"initial:%lf, final:%lf", alpha1, alpha2);
    return alpha1;
//    return alpha2 - alpha1;
}



@end
