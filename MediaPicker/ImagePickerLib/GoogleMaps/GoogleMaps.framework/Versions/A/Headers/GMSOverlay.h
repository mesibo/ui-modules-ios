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
//  GMSOverlay.h
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

@class GMSMapView;

/**
 * GMSOverlay is an abstract class that represents some overlay that may be
 * attached to a specific GMSMapView. It may not be instantiated directly;
 * instead, instances of concrete overlay types should be created directly
 * (such as GMSMarker, GMSPolyline, and GMSPolygon).
 *
 * This supports the NSCopying protocol; [overlay_ copy] will return a copy
 * of the overlay type, but with |map| set to nil.
 */
@interface GMSOverlay : NSObject<NSCopying>

/**
 * Title, a short description of the overlay. Some overlays, such as markers,
 * will display the title on the map. The title is also the default
 * accessibility text.
 */
@property(nonatomic, copy) NSString *GMS_NULLABLE_PTR title;

/**
 * The map this overlay is on. Setting this property will add the overlay to the
 * map. Setting it to nil removes this overlay from the map. An overlay may be
 * active on at most one map at any given time.
 */
@property(nonatomic, weak) GMSMapView *GMS_NULLABLE_PTR map;

/**
 * If this overlay should cause tap notifications. Some overlays, such as
 * markers, will default to being tappable.
 */
@property(nonatomic, assign, getter=isTappable) BOOL tappable;

/**
 * Higher |zIndex| value overlays will be drawn on top of lower |zIndex|
 * value tile layers and overlays.  Equal values result in undefined draw
 * ordering.  Markers are an exception that regardless of |zIndex|, they will
 * always be drawn above tile layers and other non-marker overlays; they
 * are effectively considered to be in a separate z-index group compared to
 * other overlays.
 */
@property(nonatomic, assign) int zIndex;

@end

GMS_ASSUME_NONNULL_END
