CelestialUtil
==============

Sample sources to calculate positions of the Sun and Moon using location and time.

The approximation formulas are taken from:
*ISBN=4805206349*
*日の出・日の入りの計算 : 天体の出没時刻の求め方 / 長沢工著, 東京 : 地人書館, 1999.12*


Usage
--------------

You can get azimuth angle at specific date and location using:


    -(double)azimuthAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinte TimeZone:(NSTimeZone*)zone;

e.g.

    [[[CMMoon instance] azimuthAngleAtDate:[NSDate date] inLocation:location TimeZone:[NSTimeZone defaultTimeZone]]

You can get declination as well:


    -(double)declinationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)coordinte TimeZone:(NSTimeZone*)zone;


e.g.

    [[[CMSun instance] declinationAtDate:[NSDate date] inLocation:location TimeZone:[NSTimeZone defaultTimeZone]]

Licensed under the MIT license.
