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
//  GMSPlacePicker.h
//  Google Places API for iOS
//
//  Copyright 2016 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GooglePlacePicker/GMSPlacePickerConfig.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN


/* Error domain used for Place Picker errors. */
extern NSString * const kGMSPlacePickerErrorDomain;

/* Error codes for |kGMSPlacePickerErrorDomain|. */
typedef NS_ENUM(NSInteger, GMSPlacePickerErrorCode) {
  /**
   * Something unknown went wrong.
   */
  kGMSPlacePickerUnknownError = -1,
  /**
   * An internal error occurred in the Places API library.
   */
  kGMSPlacePickerInternalError = -2,
  /**
   * An invalid GMSPlacePickerConfig was used.
   */
  kGMSPlacePickerInvalidConfig = -3,
  /**
   * Attempted to perform simultaneous place picking operations.
   */
  kGMSPlacePickerOverlappingCalls = -4,
};

/**
 * The Place Picker is a dialog that allows the user to pick a |GMSPlace| using an interactive map
 * and other tools. Users can select the place they're at or nearby.
 */
@interface GMSPlacePicker : NSObject

/**
 * The configuration of the place picker, as passed in at initialization.
 */
@property(nonatomic, readonly, copy) GMSPlacePickerConfig *config;

/**
 * Initializes the place picker with a given configuration. This does not start the process of
 * picking a place.
 */
- (instancetype)initWithConfig:(GMSPlacePickerConfig *)config;

/**
 * Prompt the user to pick a place. The place picker is a full-screen window that appears on
 * [UIScreen mainScreen]. The place picker takes over the screen until the user cancels the
 * operation or picks a place. The supplied callback will be invoked with the chosen place, or nil
 * if no place was chosen.
 *
 * This method should be called on the main thread. The callback will also be invoked on the main
 * thread.
 *
 * It is not possible to have multiple place picking operations active at the same time. If this is
 * attempted, the second callback will be invoked with an error.
 *
 * A reference to the place picker must be retained for the duration of the place picking operation.
 * If the retain count of the place picker object becomes 0, the picking operation will be cancelled
 * and the callback will not be invoked.
 */
- (void)pickPlaceWithCallback:(GMSPlaceResultCallback)callback;

@end

GMS_ASSUME_NONNULL_END
