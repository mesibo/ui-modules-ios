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
//  GMSAddress.h
//  Google Maps SDK for iOS
//
//  Copyright 2014 Google Inc.
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
#import <GoogleMaps/GMSDeprecationMacros.h>

GMS_ASSUME_NONNULL_BEGIN

/**
 * A result from a reverse geocode request, containing a human-readable address. This class is
 * immutable and should be obtained via GMSGeocoder.
 *
 * Some of the fields may be nil, indicating they are not present.
 */
@interface GMSAddress : NSObject<NSCopying>

/** Location, or kLocationCoordinate2DInvalid if unknown. */
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

/** Street number and name. */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR thoroughfare;

/** Locality or city. */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR locality;

/** Subdivision of locality, district or park. */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR subLocality;

/** Region/State/Administrative area. */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR administrativeArea;

/** Postal/Zip code. */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR postalCode;

/** The country name. */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR country;

/** An array of NSString containing formatted lines of the address. May be nil. */
@property(nonatomic, copy, readonly) GMS_NSArrayOf(NSString *) *GMS_NULLABLE_PTR lines;

/**
 * Returns the first line of the address.
 *
 * This method is obsolete and deprecated and will be removed in a future release.
 * Use the lines property instead.
 */
- (NSString *GMS_NULLABLE_PTR)addressLine1 __GMS_AVAILABLE_BUT_DEPRECATED;

/**
 * Returns the second line of the address.
 *
 * This method is obsolete and deprecated and will be removed in a future release.
 * Use the lines property instead.
 */
- (NSString *GMS_NULLABLE_PTR)addressLine2 __GMS_AVAILABLE_BUT_DEPRECATED;

@end

/**
 * The former type of geocode results (pre-1.7). This remains here for migration and will be
 * removed in future releases.
 */
@compatibility_alias GMSReverseGeocodeResult GMSAddress;

GMS_ASSUME_NONNULL_END
