CelestialUtil
==============

Sample sources to calculate positions of the Sun and Moon using location and date.

The approximation formulas are taken from:
*ISBN=4805206349*
*日の出・日の入りの計算 : 天体の出没時刻の求め方 / 長沢工著, 東京 : 地人書館, 1999.12*


## Usage

### Azimuth

You can get azimuth angle at specific date and location using:


    -(double)azimuthAngleAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)location;

e.g.

    [[CMMoon new] azimuthAngleAtDate:date inLocation:location]



### Declination
You can get declination angle at specific date using:


    -(double)declinationAtDate:(NSDate*)date;


e.g.

    [[CMSun new] declinationAtDate:date]

### Elevation
You can get elevation (i.e. altitude) angle at specific date and location using:


    -(double)elevationAtDate:(NSDate*)date inLocation:(CLLocationCoordinate2D)location;


e.g.

    [[CMSun new] elevationAtDate:date inLocation:location]


### Geocentric Distance
You can get geocentric distance at specific date using:


    -(double)geocentricDistanceAtDate:(NSDate*)date;


e.g.

    [[CMSun new] geocentricDistanceAtDate:date]

## ARC
CelestialUtil needs ARC.

## License

Licensed under the MIT license.
