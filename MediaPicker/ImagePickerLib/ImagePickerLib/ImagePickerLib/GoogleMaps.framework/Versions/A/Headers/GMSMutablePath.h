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
//  GMSMutablePath.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMaps/GMSPath.h>

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

/**
 * GMSMutablePath is a dynamic (resizable) array of CLLocationCoordinate2D. All coordinates must be
 * valid. GMSMutablePath is the mutable counterpart to the immutable GMSPath.
 */
@interface GMSMutablePath : GMSPath

/** Adds |coord| at the end of the path. */
- (void)addCoordinate:(CLLocationCoordinate2D)coord;

/** Adds a new CLLocationCoordinate2D instance with the given lat/lng. */
- (void)addLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

/**
 * Inserts |coord| at |index|.
 *
 * If this is smaller than the size of the path, shifts all coordinates forward by one. Otherwise,
 * behaves as replaceCoordinateAtIndex:withCoordinate:.
 */
- (void)insertCoordinate:(CLLocationCoordinate2D)coord atIndex:(NSUInteger)index;

/**
 * Replace the coordinate at |index| with |coord|. If |index| is after the end, grows the array with
 * an undefined coordinate.
 */
- (void)replaceCoordinateAtIndex:(NSUInteger)index
                  withCoordinate:(CLLocationCoordinate2D)coord;

/**
 * Remove entry at |index|.
 *
 * If |index| < count decrements size. If |index| >= count this is a silent
 * no-op.
 */
- (void)removeCoordinateAtIndex:(NSUInteger)index;

/**
 * Removes the last coordinate of the path.
 *
 * If the array is non-empty decrements size. If the array is empty, this is a silent no-op.
 */
- (void)removeLastCoordinate;

/** Removes all coordinates in this path. */
- (void)removeAllCoordinates;

@end
