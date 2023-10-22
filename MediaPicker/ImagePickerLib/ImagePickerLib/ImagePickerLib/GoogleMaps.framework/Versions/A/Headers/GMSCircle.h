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
//  GMSCircle.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMaps/GMSOverlay.h>

#import <Foundation/Foundation.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * A circle on the Earth's surface (spherical cap).
 */
@interface GMSCircle : GMSOverlay

/** Position on Earth of circle center. */
@property(nonatomic, assign) CLLocationCoordinate2D position;

/** Radius of the circle in meters; must be positive. */
@property(nonatomic, assign) CLLocationDistance radius;

/**
 * The width of the circle's outline in screen points. Defaults to 1. As per
 * GMSPolygon, the width does not scale when the map is zoomed.
 * Setting strokeWidth to 0 results in no stroke.
 */
@property(nonatomic, assign) CGFloat strokeWidth;

/** The color of this circle's outline. The default value is black. */
@property(nonatomic, strong) UIColor *GMS_NULLABLE_PTR strokeColor;

/**
 * The interior of the circle is painted with fillColor.
 * The default value is nil, resulting in no fill.
 */
@property(nonatomic, strong) UIColor *GMS_NULLABLE_PTR fillColor;

/**
 * Convenience constructor for GMSCircle for a particular position and radius.
 * Other properties will have default values.
 */
+ (instancetype)circleWithPosition:(CLLocationCoordinate2D)position
                            radius:(CLLocationDistance)radius;

@end

GMS_ASSUME_NONNULL_END
