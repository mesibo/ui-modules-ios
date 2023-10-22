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
//  GMSPlaceLikelihoodList.h
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

@class GMSPlaceLikelihood;

/**
 * Represents a list of places with an associated likelihood for the place being the correct place.
 * For example, the Places service may be uncertain what the true Place is, but think it 55% likely
 * to be PlaceA, and 35% likely to be PlaceB. The corresponding likelihood list has two members, one
 * with likelihood 0.55 and the other with likelihood 0.35. The likelihoods are not guaranteed to be
 * correct, and in a given place likelihood list they may not sum to 1.0.
 */
@interface GMSPlaceLikelihoodList : NSObject

/** An array of |GMSPlaceLikelihood|s containing the likelihoods in the list. */
@property(nonatomic, copy) GMS_NSArrayOf(GMSPlaceLikelihood *) * likelihoods;

/**
 * The data provider attribution strings for the likelihood list.
 *
 * These are provided as a NSAttributedString, which may contain hyperlinks to the website of each
 * provider.
 *
 * In general, these must be shown to the user if data from this likelihood list is shown, as
 * described in the Places API Terms of Service.
 */
@property(nonatomic, copy, readonly) NSAttributedString *GMS_NULLABLE_PTR attributions;

@end

GMS_ASSUME_NONNULL_END
