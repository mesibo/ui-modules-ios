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
//  GMSPolygon.h
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
#import <GoogleMaps/GMSOverlay.h>

GMS_ASSUME_NONNULL_BEGIN

@class GMSPath;

/**
 * GMSPolygon defines a polygon that appears on the map. A polygon (like a polyline) defines a
 * series of connected coordinates in an ordered sequence; additionally, polygons form a closed loop
 * and define a filled region.
 */
@interface GMSPolygon : GMSOverlay

/** The path that describes this polygon. The coordinates composing the path must be valid. */
@property(nonatomic, copy) GMSPath *GMS_NULLABLE_PTR path;

/**
 * The array of GMSPath instances that describes any holes in this polygon. The coordinates
 * composing each path must be valid.
 */
@property(nonatomic, copy) GMS_NSArrayOf(GMSPath *) * GMS_NULLABLE_PTR holes;

/** The width of the polygon outline in screen points. Defaults to 1. */
@property(nonatomic, assign) CGFloat strokeWidth;

/** The color of the polygon outline. Defaults to nil. */
@property(nonatomic, strong) UIColor *GMS_NULLABLE_PTR strokeColor;

/** The fill color. Defaults to blueColor. */
@property(nonatomic, strong) UIColor *GMS_NULLABLE_PTR fillColor;

/** Whether this polygon should be rendered with geodesic correction. */
@property(nonatomic, assign) BOOL geodesic;

/**
 * Convenience constructor for GMSPolygon for a particular path. Other properties will have default
 * values.
 */
+ (instancetype)polygonWithPath:(GMSPath *GMS_NULLABLE_PTR)path;

@end

GMS_ASSUME_NONNULL_END
