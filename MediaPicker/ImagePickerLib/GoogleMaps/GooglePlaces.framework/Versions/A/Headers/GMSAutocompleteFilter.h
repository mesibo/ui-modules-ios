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
//  GMSAutocompleteFilter.h
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

/**
 * The type filters that may be applied to an autocomplete request to restrict results to different
 * types.
 */
typedef NS_ENUM(NSInteger, GMSPlacesAutocompleteTypeFilter) {
  /**
   * All results.
   */
  kGMSPlacesAutocompleteTypeFilterNoFilter,
  /**
   * Geeocoding results, as opposed to business results.
   */
  kGMSPlacesAutocompleteTypeFilterGeocode,
  /**
   * Geocoding results with a precise address.
   */
  kGMSPlacesAutocompleteTypeFilterAddress,
  /**
   * Business results.
   */
  kGMSPlacesAutocompleteTypeFilterEstablishment,
  /**
   * Results that match the following types:
   * "locality",
   * "sublocality"
   * "postal_code",
   * "country",
   * "administrative_area_level_1",
   * "administrative_area_level_2"
   */
  kGMSPlacesAutocompleteTypeFilterRegion,
  /**
   * Results that match the following types:
   * "locality",
   * "administrative_area_level_3"
   */
  kGMSPlacesAutocompleteTypeFilterCity,
};

/**
 * This class represents a set of restrictions that may be applied to autocomplete requests. This
 * allows customization of autocomplete suggestions to only those places that are of interest.
 */
@interface GMSAutocompleteFilter : NSObject

/**
 * The type filter applied to an autocomplete request to restrict results to different types.
 * Default value is kGMSPlacesAutocompleteTypeFilterNoFilter.
 */
@property(nonatomic, assign) GMSPlacesAutocompleteTypeFilter type;

/**
 * The country to restrict results to. This should be a ISO 3166-1 Alpha-2 country code (case
 * insensitive). If nil, no country filtering will take place.
 */
@property(nonatomic, copy) NSString *GMS_NULLABLE_PTR country;

@end

GMS_ASSUME_NONNULL_END
