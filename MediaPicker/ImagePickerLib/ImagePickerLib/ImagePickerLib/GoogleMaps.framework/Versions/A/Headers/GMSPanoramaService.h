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
//  GMSPanoramaService.h
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

@class GMSPanorama;

GMS_ASSUME_NONNULL_BEGIN

/**
 * Callback for when a panorama metadata becomes available.
 * If an error occured, |panorama| is nil and |error| is not nil.
 * Otherwise, |panorama| is not nil and |error| is nil.
 */
typedef void (^GMSPanoramaCallback)(GMSPanorama *GMS_NULLABLE_PTR panorama,
                                    NSError *GMS_NULLABLE_PTR error);

/**
 * GMSPanoramaService can be used to request panorama metadata even when a
 * GMSPanoramaView is not active.
 * Get an instance like this: [[GMSPanoramaService alloc] init].
 */
@interface GMSPanoramaService : NSObject

/**
 * Retrieves information about a panorama near the given |coordinate|.
 * This is an asynchronous request, |callback| will be called with the result.
 */
- (void)requestPanoramaNearCoordinate:(CLLocationCoordinate2D)coordinate
                             callback:(GMSPanoramaCallback)callback;

/**
 * Similar to requestPanoramaNearCoordinate:callback: but allows specifying
 * a search radius (meters) around |coordinate|.
 */
- (void)requestPanoramaNearCoordinate:(CLLocationCoordinate2D)coordinate
                               radius:(NSUInteger)radius
                             callback:(GMSPanoramaCallback)callback;

/**
 * Retrieves information about a panorama with the given |panoramaID|.
 * |callback| will be called with the result. Only panoramaIDs obtained
 * from the Google Maps SDK for iOS are supported.
 */
- (void)requestPanoramaWithID:(NSString *)panoramaID callback:(GMSPanoramaCallback)callback;

@end

GMS_ASSUME_NONNULL_END
