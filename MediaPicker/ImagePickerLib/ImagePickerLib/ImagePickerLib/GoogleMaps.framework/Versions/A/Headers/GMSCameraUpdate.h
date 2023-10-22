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
//  GMSCameraUpdate.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

@class GMSCameraPosition;
@class GMSCoordinateBounds;

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSCameraUpdate represents an update that may be applied to a GMSMapView.
 * It encapsulates some logic for modifying the current camera.
 * It should only be constructed using the factory helper methods below.
 */
@interface GMSCameraUpdate : NSObject

/**
 * Returns a GMSCameraUpdate that zooms in on the map.
 * The zoom increment is 1.0.
 */
+ (GMSCameraUpdate *)zoomIn;

/**
 * Returns a GMSCameraUpdate that zooms out on the map.
 * The zoom increment is -1.0.
 */
+ (GMSCameraUpdate *)zoomOut;

/**
 * Returns a GMSCameraUpdate that changes the zoom by the specified amount.
 */
+ (GMSCameraUpdate *)zoomBy:(float)delta;

/**
 * Returns a GMSCameraUpdate that sets the zoom to the specified amount.
 */
+ (GMSCameraUpdate *)zoomTo:(float)zoom;

/**
 * Returns a GMSCameraUpdate that sets the camera target to the specified
 * coordinate.
 */
+ (GMSCameraUpdate *)setTarget:(CLLocationCoordinate2D)target;

/**
 * Returns a GMSCameraUpdate that sets the camera target and zoom to the
 * specified values.
 */
+ (GMSCameraUpdate *)setTarget:(CLLocationCoordinate2D)target zoom:(float)zoom;

/**
 * Returns a GMSCameraUpdate that sets the camera to the specified
 * GMSCameraPosition.
 */
+ (GMSCameraUpdate *)setCamera:(GMSCameraPosition *)camera;

/**
 * Returns a GMSCameraUpdate that transforms the camera such that the specified
 * bounds are centered on screen at the greatest possible zoom level. The bounds
 * will have a default padding of 64 points.
 *
 * The returned camera update will set the camera's bearing and tilt to their
 * default zero values (i.e., facing north and looking directly at the Earth).
 */
+ (GMSCameraUpdate *)fitBounds:(GMSCoordinateBounds *)bounds;

/**
 * This is similar to fitBounds: but allows specifying the padding (in points)
 * in order to inset the bounding box from the view's edges.
 * If the requested |padding| is larger than the view size in either the
 * vertical or horizontal direction the map will be maximally zoomed out.
 */
+ (GMSCameraUpdate *)fitBounds:(GMSCoordinateBounds *)bounds
                   withPadding:(CGFloat)padding;

/**
 * This is similar to fitBounds: but allows specifying edge insets
 * in order to inset the bounding box from the view's edges.
 * If the requested |edgeInsets| are larger than the view size in either the
 * vertical or horizontal direction the map will be maximally zoomed out.
 */
+ (GMSCameraUpdate *)fitBounds:(GMSCoordinateBounds *)bounds
                withEdgeInsets:(UIEdgeInsets)edgeInsets;

/**
 * Returns a GMSCameraUpdate that shifts the center of the view by the
 * specified number of points in the x and y directions.
 * X grows to the right, Y grows down.
 */
+ (GMSCameraUpdate *)scrollByX:(CGFloat)dX Y:(CGFloat)dY;

/**
 * Returns a GMSCameraUpdate that zooms with a focus point; the focus point
 * stays fixed on screen.
 */
+ (GMSCameraUpdate *)zoomBy:(float)zoom atPoint:(CGPoint)point;

@end

GMS_ASSUME_NONNULL_END
