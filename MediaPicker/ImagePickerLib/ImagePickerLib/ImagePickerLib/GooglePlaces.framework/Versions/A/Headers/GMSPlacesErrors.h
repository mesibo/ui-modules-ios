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
//  GMSPlacesErrors.h
//  Google Places API for iOS
//
//  Copyright 2016 Google Inc.
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

/* Error domain used for Places API errors. */
extern NSString * const kGMSPlacesErrorDomain;

/* Error codes for |kGMSPlacesErrorDomain|. */
typedef NS_ENUM(NSInteger, GMSPlacesErrorCode) {
  /**
   * Something went wrong with the connection to the Places API server.
   */
  kGMSPlacesNetworkError = -1,
  /**
   * The Places API server returned a response that we couldn't understand.
   * <p>
   * If you believe this error represents a bug, please file a report using the instructions on our
   * <a href=https://developers.google.com/places/support">community and support page</a>.
   */
  kGMSPlacesServerError = -2,
  /**
   * An internal error occurred in the Places API library.
   * <p>
   * If you believe this error represents a bug, please file a report using the instructions on our
   * <a href=https://developers.google.com/places/support">community and support page</a>.
   */
  kGMSPlacesInternalError = -3,
  /**
   * Operation failed due to an invalid (malformed or missing) API key.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a>
   * for information on creating and using an API key.
   */
  kGMSPlacesKeyInvalid = -4,
  /**
   * Operation failed due to an expired API key.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a>
   * for information on creating and using an API key.
   */
  kGMSPlacesKeyExpired = -5,
  /**
   * Operation failed due to exceeding the quota usage limit.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/usage">usage limits guide</a>
   * for information on usage limits and how to request a higher limit.
   */
  kGMSPlacesUsageLimitExceeded = -6,
  /**
   * Operation failed due to exceeding the usage rate limit for the API key.
   * <p>
   * This status code shouldn't be returned during normal usage of the API. It relates to usage of
   * the API that far exceeds normal request levels. See the <a
   * href="https://developers.google.com/places/ios-api/usage">usage limits guide</a> for more
   * information.
   */
  kGMSPlacesRateLimitExceeded = -7,
  /**
   * Operation failed due to exceeding the per-device usage rate limit.
   * <p>
   * This status code shouldn't be returned during normal usage of the API. It relates to usage of
   * the API that far exceeds normal request levels. See the <a
   * href="https://developers.google.com/places/ios-api/usage">usage limits guide</a> for more
   * information.
   */
  kGMSPlacesDeviceRateLimitExceeded = -8,
  /**
   * The Places API for iOS is not enabled.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a> for how
   * to enable the Google Places API for iOS.
   */
  kGMSPlacesAccessNotConfigured = -9,
  /**
   * The application's bundle identifier does not match one of the allowed iOS applications for the
   * API key.
   * <p>
   * See the <a href="https://developers.google.com/places/ios/start">developer's guide</a>
   * for how to configure bundle restrictions on API keys.
   */
  kGMSPlacesIncorrectBundleIdentifier = -10,
  /**
   * The Places API could not find the user's location. This may be because the user has not allowed
   * the application to access location information.
   */
  kGMSPlacesLocationError = -11
};

GMS_ASSUME_NONNULL_END
