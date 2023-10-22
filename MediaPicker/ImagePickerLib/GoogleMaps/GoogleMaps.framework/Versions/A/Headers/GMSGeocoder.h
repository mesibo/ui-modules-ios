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
//  GMSGeocoder.h
//  Google Maps SDK for iOS
//
//  Copyright 2012 Google Inc.
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
#import <GoogleMaps/GMSAddress.h>

GMS_ASSUME_NONNULL_BEGIN

@class GMSReverseGeocodeResponse;

/** GMSGeocoder error codes, embedded in NSError. */
typedef NS_ENUM(NSInteger, GMSGeocoderErrorCode) {
  kGMSGeocoderErrorInvalidCoordinate = 1,
  kGMSGeocoderErrorInternal,
};

/** Handler that reports a reverse geocoding response, or error. */
typedef void (^GMSReverseGeocodeCallback)(GMSReverseGeocodeResponse *GMS_NULLABLE_PTR,
                                          NSError *GMS_NULLABLE_PTR);

/**
 * Exposes a service for reverse geocoding. This maps Earth coordinates (latitude and longitude) to
 * a collection of addresses near that coordinate.
 */
@interface GMSGeocoder : NSObject

/* Convenience constructor for GMSGeocoder. */
+ (GMSGeocoder *)geocoder;

/**
 * Reverse geocodes a coordinate on the Earth's surface.
 *
 * @param coordinate The coordinate to reverse geocode.
 * @param handler The callback to invoke with the reverse geocode results.
 *        The callback will be invoked asynchronously from the main thread.
 */
- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate
               completionHandler:(GMSReverseGeocodeCallback)handler;

@end

/** A collection of results from a reverse geocode request. */
@interface GMSReverseGeocodeResponse : NSObject<NSCopying>

/** Returns the first result, or nil if no results were available. */
- (GMSAddress *GMS_NULLABLE_PTR)firstResult;

/** Returns an array of all the results (contains GMSAddress), including the first result. */
- (GMS_NSArrayOf(GMSAddress *) * GMS_NULLABLE_PTR)results;

@end

GMS_ASSUME_NONNULL_END
