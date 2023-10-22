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
//  GMSMarkerLayer.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSMarkerLayer is a custom subclass of CALayer, available on a per-marker
 * basis, that allows animation of several properties of its associated
 * GMSMarker.
 *
 * Note that this CALayer is never actually rendered directly, as GMSMapView is
 * provided entirely via an OpenGL layer. As such, adjustments or animations to
 * 'default' properties of CALayer will not have any effect.
 */
@interface GMSMarkerLayer : CALayer

/** Latitude, part of |position| on GMSMarker. */
@property(nonatomic, assign) CLLocationDegrees latitude;

/** Longitude, part of |position| on GMSMarker. */
@property(nonatomic, assign) CLLocationDegrees longitude;

/** Rotation, as per GMSMarker. */
@property(nonatomic, assign) CLLocationDegrees rotation;

/** Opacity, as per GMSMarker. */
@property float opacity;

@end

extern NSString *const kGMSMarkerLayerLatitude;
extern NSString *const kGMSMarkerLayerLongitude;
extern NSString *const kGMSMarkerLayerRotation;
extern NSString *const kGMSMarkerLayerOpacity;

GMS_ASSUME_NONNULL_END
