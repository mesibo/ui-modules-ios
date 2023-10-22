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
//  GMSPanorama.h
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

@class GMSPanoramaLink;

/**
 * GMSPanorama represents metadata for a specific panorama on the Earth. This class is not
 * instantiable directly and is obtained via GMSPanoramaService or GMSPanoramaView.
 */
@interface GMSPanorama : NSObject

/** The precise location of this panorama. */
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

/** The ID of this panorama. Panoramas may change ID over time, so this should not be persisted */
@property(nonatomic, copy, readonly) NSString *panoramaID;

/** An array of GMSPanoramaLink describing the neighboring panoramas. */
@property(nonatomic, copy, readonly) GMS_NSArrayOf(GMSPanoramaLink *) * links;

@end

GMS_ASSUME_NONNULL_END
