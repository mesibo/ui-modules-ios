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
//  GMSPanoramaCameraUpdate.h
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

GMS_ASSUME_NONNULL_BEGIN

@interface GMSPanoramaCameraUpdate : NSObject

/** Returns an update that increments the camera heading with |deltaHeading|. */
+ (GMSPanoramaCameraUpdate *)rotateBy:(CGFloat)deltaHeading;

/** Returns an update that sets the camera heading to the given value. */
+ (GMSPanoramaCameraUpdate *)setHeading:(CGFloat)heading;

/** Returns an update that sets the camera pitch to the given value. */
+ (GMSPanoramaCameraUpdate *)setPitch:(CGFloat)pitch;

/** Returns an update that sets the camera zoom to the given value. */
+ (GMSPanoramaCameraUpdate *)setZoom:(CGFloat)zoom;

@end

GMS_ASSUME_NONNULL_END
