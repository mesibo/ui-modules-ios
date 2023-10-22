/******************************************************************************
* By accessing or copying this work, you agree to comply with the following   *
* terms:                                                                      *
*                                                                             *
* Copyright (c) 2019-2023 mesibo                                              *
* https://mesibo.com                                                          *
* All rights reserved.                                                        *
*                                                                             *
* Redistribution is not permitted. Use of this software is subject to the     *
* conditions specified at https://mesibo.com . When using the source code,    *
* maintain the copyright notice, conditions, disclaimer, and  links to mesibo * 
* website, documentation and the source code repository.                      *
*                                                                             *
* Do not use the name of mesibo or its contributors to endorse products from  *
* this software without prior written permission.                             *
*                                                                             *
* This software is provided "as is" without warranties. mesibo and its        *
* contributors are not liable for any damages arising from its use.           *
*                                                                             *
* Documentation: https://mesibo.com/documentation/                            *
*                                                                             *
* Source Code Repository: https://github.com/mesibo/                          *
*******************************************************************************/

//
//  GMSPath.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSPath encapsulates an immutable array of CLLocationCooordinate2D. All the coordinates of a
 * GMSPath must be valid. The mutable counterpart is GMSMutablePath.
 */
@interface GMSPath : NSObject<NSCopying, NSMutableCopying>

/** Convenience constructor for an empty path. */
+ (instancetype)path;

/** Initializes a newly allocated path with the contents of another GMSPath. */
- (id)initWithPath:(GMSPath *)path;

/** Get size of path. */
- (NSUInteger)count;

/** Returns kCLLocationCoordinate2DInvalid if |index| >= count. */
- (CLLocationCoordinate2D)coordinateAtIndex:(NSUInteger)index;

/**
 * Initializes a newly allocated path from |encodedPath|. This format is described at:
 * https://developers.google.com/maps/documentation/utilities/polylinealgorithm
 */
+ (GMS_NULLABLE_INSTANCETYPE)pathFromEncodedPath:(NSString *)encodedPath;

/** Returns an encoded string of the path in the format described above. */
- (NSString *)encodedPath;

/**
 * Returns a new path obtained by adding |deltaLatitude| and |deltaLongitude| to each coordinate
 * of the current path. Does not modify the current path.
 */
- (instancetype)pathOffsetByLatitude:(CLLocationDegrees)deltaLatitude
                           longitude:(CLLocationDegrees)deltaLongitude;

@end

/**
 * kGMSEquatorProjectedMeter may be useful when specifying lengths for segment in "projected" units.
 * The value of kGMSEquatorProjectedMeter, 1/(pi * EarthRadius), represents the length of one meter
 * at the equator in projected units. For example to specify a projected length that corresponds
 * to 100km at the equator use 100000 * kGMSEquatorProjectedMeter.
 * See [GMSPath segmentsForLength:kind:], [GMSPath lengthOfKind:] and kGMSLengthProjected.
 */
extern const double kGMSEquatorProjectedMeter;

/**
 * GMSLengthKind indicates the type of a length value, which can be geodesic (in meters), rhumb
 * length (in meters) and projected length (in GMSMapPoint units).
 */
typedef enum {
  /*
   * Geodesic length, in meters, along geodesic segments. May be useful, for example, to specify
   * lengths along the the trajectory of airplanes or ships.
   */
  kGMSLengthGeodesic,

  /*
   * Rhumb length, in meters, along rhumb (straight line) segments. May be useful, for example, to
   * draw a scale bar on a map. The visual size of a segment of a given length depens on the
   * latitude.
   */
  kGMSLengthRhumb,

  /*
   * Length in projected space, along rhumb segments. Projected length uses the same units as
   * GMSMapPoint - the Earth equator circumference has length 2. It is possible to specify projected
   * length in units corresponding to 1 meter at the equator by multiplying with
   * kGMSEquatorProjectedMeter, equal to 1/(pi * EarthRadius).
   *
   * Projected length may be useful, for example, to specify segments with the same visual length
   * regardless of latitude.
   */
  kGMSLengthProjected
} GMSLengthKind;

@interface GMSPath (GMSPathLength)

/**
 * Returns the fractional number of segments along the path that correspond to |length|,
 * interpreted according to |kind|. See GMSLengthKind.
 */
- (double)segmentsForLength:(CLLocationDistance)length kind:(GMSLengthKind)kind;

/**
 * Returns the length of the path, according to |kind|. See GMSLengthKind.
 */
- (CLLocationDistance)lengthOfKind:(GMSLengthKind)kind;

@end

GMS_ASSUME_NONNULL_END
