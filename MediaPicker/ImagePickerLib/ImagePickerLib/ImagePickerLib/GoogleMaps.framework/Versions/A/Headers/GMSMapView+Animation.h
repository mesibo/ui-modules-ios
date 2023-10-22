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
//  GMSMapView+Animation.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMaps/GMSMapView.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSMapView (Animation) offers several animation helper methods.
 *
 * During any animation, retrieving the camera position through the camera
 * property on GMSMapView returns an intermediate immutable GMSCameraPosition.
 * This camera position will typically represent the most recently drawn frame.
 */
@interface GMSMapView (Animation)

/** Animates the camera of this map to |cameraPosition|. */
- (void)animateToCameraPosition:(GMSCameraPosition *)cameraPosition;

/**
 * As animateToCameraPosition:, but changes only the location of the camera
 * (i.e., from the current location to |location|).
 */
- (void)animateToLocation:(CLLocationCoordinate2D)location;

/**
 * As animateToCameraPosition:, but changes only the zoom level of the camera.
 * This value is clamped by [kGMSMinZoomLevel, kGMSMaxZoomLevel].
 */
- (void)animateToZoom:(float)zoom;

/**
 * As animateToCameraPosition:, but changes only the bearing of the camera (in
 * degrees). Zero indicates true north.
 */
- (void)animateToBearing:(CLLocationDirection)bearing;

/**
 * As animateToCameraPosition:, but changes only the viewing angle of the camera
 * (in degrees). This value will be clamped to a minimum of zero (i.e., facing
 * straight down) and between 30 and 45 degrees towards the horizon, depending
 * on the relative closeness to the earth.
 */
- (void)animateToViewingAngle:(double)viewingAngle;

/**
 * Applies |cameraUpdate| to the current camera, and then uses the result as
 * per animateToCameraPosition:.
 */
- (void)animateWithCameraUpdate:(GMSCameraUpdate *)cameraUpdate;

@end

GMS_ASSUME_NONNULL_END
