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
//  GMSIndoorDisplay.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <Foundation/Foundation.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

@class GMSIndoorBuilding;
@class GMSIndoorLevel;

GMS_ASSUME_NONNULL_BEGIN

/** Delegate for events on GMSIndoorDisplay. */
@protocol GMSIndoorDisplayDelegate<NSObject>
@optional

/**
 * Raised when the activeBuilding has changed.  The activeLevel will also have
 * already been updated for the new building, but didChangeActiveLevel: will
 * be raised after this method.
 */
- (void)didChangeActiveBuilding:(GMSIndoorBuilding *GMS_NULLABLE_PTR)building;

/**
 * Raised when the activeLevel has changed.  This event is raised for all
 * changes, including explicit setting of the property.
 */
- (void)didChangeActiveLevel:(GMSIndoorLevel *GMS_NULLABLE_PTR)level;

@end

/**
 * Provides ability to observe or control the display of indoor level data.
 *
 * Like GMSMapView, GMSIndoorDisplay may only be used from the main thread.
 */
@interface GMSIndoorDisplay : NSObject

/** GMSIndoorDisplay delegate */
@property(nonatomic, weak) id<GMSIndoorDisplayDelegate> GMS_NULLABLE_PTR delegate;

/**
 * Provides the currently focused building, will be nil if there is no
 * building with indoor data currently under focus.
 */
@property(nonatomic, strong, readonly) GMSIndoorBuilding *GMS_NULLABLE_PTR activeBuilding;

/**
 * Provides and controls the active level for activeBuilding.  Will be updated
 * whenever activeBuilding changes, and may be set to any member of
 * activeBuilding's levels property.  May also be set to nil if the building is
 * underground, to stop showing the building (the building will remain active).
 * Will always be nil if activeBuilding is nil.
 * Any attempt to set it to an invalid value will be ignored.
 */
@property(nonatomic, strong) GMSIndoorLevel *GMS_NULLABLE_PTR activeLevel;

@end

GMS_ASSUME_NONNULL_END
