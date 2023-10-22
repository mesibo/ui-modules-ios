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
//  GMSPanoramaLayer.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#import <GoogleMaps/GMSCALayer.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/** kGMSLayerPanoramaHeadingKey ranges from [0, 360). */
extern NSString *const kGMSLayerPanoramaHeadingKey;

/** kGMSLayerPanoramaPitchKey ranges from [-90, 90]. */
extern NSString *const kGMSLayerPanoramaPitchKey;

/** kGMSLayerCameraZoomLevelKey ranges from [1, 5], default 1. */
extern NSString *const kGMSLayerPanoramaZoomKey;

/** kGMSLayerPanoramaFOVKey ranges from [1, 160] (in degrees), default 90. */
extern NSString *const kGMSLayerPanoramaFOVKey;

/**
 * GMSPanoramaLayer is a custom subclass of CALayer, provided as the layer
 * class on GMSPanoramaView. This layer should not be instantiated directly.
 */
@interface GMSPanoramaLayer : GMSCALayer
@property(nonatomic, assign) CLLocationDirection cameraHeading;
@property(nonatomic, assign) double cameraPitch;
@property(nonatomic, assign) float cameraZoom;
@property(nonatomic, assign) double cameraFOV;
@end

GMS_ASSUME_NONNULL_END
