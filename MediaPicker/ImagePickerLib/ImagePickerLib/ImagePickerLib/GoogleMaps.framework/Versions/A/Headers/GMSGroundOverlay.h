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
//  GMSGroundOverlay.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMaps/GMSOverlay.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

@class GMSCoordinateBounds;

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSGroundOverlay specifies the available options for a ground overlay that
 * exists on the Earth's surface. Unlike a marker, the position of a ground
 * overlay is specified explicitly and it does not face the camera.
 */
@interface GMSGroundOverlay : GMSOverlay

/**
 * The position of this GMSGroundOverlay, or more specifically, the physical
 * position of its anchor. If this is changed, |bounds| will be moved around
 * the new position.
 */
@property(nonatomic, assign) CLLocationCoordinate2D position;

/**
 * The anchor specifies where this GMSGroundOverlay is anchored to the Earth in
 * relation to |bounds|. If this is modified, |position| will be set to the
 * corresponding new position within |bounds|.
 */
@property(nonatomic, assign) CGPoint anchor;

/**
 * Icon to render within |bounds| on the Earth. If this is nil, the overlay will
 * not be visible (unlike GMSMarker which has a default image).
 */
@property(nonatomic, strong) UIImage *GMS_NULLABLE_PTR icon;

/**
 * Sets the opacity of the ground overlay, between 0 (completely transparent)
 * and 1 (default) inclusive.
 */
@property(nonatomic, assign) float opacity;

/**
 * Bearing of this ground overlay, in degrees. The default value, zero, points
 * this ground overlay up/down along the normal Y axis of the earth.
 */
@property(nonatomic, assign) CLLocationDirection bearing;

/**
 * The 2D bounds on the Earth in which |icon| is drawn. Changing this value
 * will adjust |position| accordingly.
 */
@property(nonatomic, strong) GMSCoordinateBounds *GMS_NULLABLE_PTR bounds;

/**
 * Convenience constructor for GMSGroundOverlay for a particular |bounds| and
 * |icon|. Will set |position| accordingly.
 */
+ (instancetype)groundOverlayWithBounds:(GMSCoordinateBounds *GMS_NULLABLE_PTR)bounds
                                   icon:(UIImage *GMS_NULLABLE_PTR)icon;

/**
 * Constructs a GMSGroundOverlay that renders the given |icon| at |position|,
 * as if the image's actual size matches camera pixels at |zoomLevel|.
 */
+ (instancetype)groundOverlayWithPosition:(CLLocationCoordinate2D)position
                                     icon:(UIImage *GMS_NULLABLE_PTR)icon
                                zoomLevel:(CGFloat)zoomLevel;

@end

/**
 * The default position of the ground anchor of a GMSGroundOverlay: the center
 * point of the icon.
 */
FOUNDATION_EXTERN const CGPoint kGMSGroundOverlayDefaultAnchor;

GMS_ASSUME_NONNULL_END
