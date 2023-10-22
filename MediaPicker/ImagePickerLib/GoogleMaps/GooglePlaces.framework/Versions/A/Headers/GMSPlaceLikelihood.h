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
//  GMSPlaceLikelihood.h
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

@class GMSPlace;

/**
 * Represents a |GMSPlace| and the relative likelihood of the place being the best match within the
 * list of returned places for a single request. For more information about place likelihoods, see
 * |GMSPlaceLikelihoodList|.
 */
@interface GMSPlaceLikelihood : NSObject<NSCopying>

/**
 * The place contained in this place likelihood.
 */
@property(nonatomic, strong, readonly) GMSPlace *place;

/**
 * Returns a value from 0.0 to 1.0 indicating the confidence that the user is at this place. The
 * larger the value the more confident we are of the place returned. For example, a likelihood of
 * 0.75 means that the user is at least 75% likely to be at this place.
 */
@property(nonatomic, assign, readonly) double likelihood;

- (instancetype)initWithPlace:(GMSPlace *)place likelihood:(double)likelihood;

@end

GMS_ASSUME_NONNULL_END
