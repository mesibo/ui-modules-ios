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
//  GMSCoordinateBounds+GoogleMaps.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//


#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

#import <GoogleMaps/GMSProjection.h>

@class GMSPath;

GMS_ASSUME_NONNULL_BEGIN

@interface GMSCoordinateBounds (GoogleMaps)

/**
 * Inits with bounds that encompass |region|.
 */
- (id)initWithRegion:(GMSVisibleRegion)region;

/**
 * Inits with bounds that encompass |path|.
 */
- (id)initWithPath:(GMSPath *)path;

/**
 * Returns a GMSCoordinateBounds representing the current bounds extended to
 * include |path|.
 */
- (GMSCoordinateBounds *)includingPath:(GMSPath *)path;

@end

GMS_ASSUME_NONNULL_END
