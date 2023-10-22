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
//  GMSAutocompletePrediction.h
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

/*
 * Attribute name for match fragments in |GMSAutocompletePrediction| attributedFullText.
 */
extern NSString *const kGMSAutocompleteMatchAttribute;

/**
 * This class represents a prediction of a full query based on a partially typed string.
 */
@interface GMSAutocompletePrediction : NSObject

/**
 * The full description of the prediction as a NSAttributedString. E.g., "Sydney Opera House,
 * Sydney, New South Wales, Australia".
 *
 * Every text range that matches the user input has a |kGMSAutocompleteMatchAttribute|.  For
 * example, you can make every match bold using enumerateAttribute:
 * <pre>
 *   UIFont *regularFont = [UIFont systemFontOfSize:[UIFont labelFontSize]];
 *   UIFont *boldFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
 *
 *   NSMutableAttributedString *bolded = [prediction.attributedFullText mutableCopy];
 *   [bolded enumerateAttribute:kGMSAutocompleteMatchAttribute
 *                      inRange:NSMakeRange(0, bolded.length)
 *                      options:0
 *                   usingBlock:^(id value, NSRange range, BOOL *stop) {
 *                     UIFont *font = (value == nil) ? regularFont : boldFont;
 *                     [bolded addAttribute:NSFontAttributeName value:font range:range];
 *                   }];
 *
 *   label.attributedText = bolded;
 * </pre>
 */
@property(nonatomic, copy, readonly) NSAttributedString *attributedFullText;

/**
 * The main text of a prediction as a NSAttributedString, usually the name of the place.
 * E.g. "Sydney Opera House".
 *
 * Text ranges that match user input are have a |kGMSAutocompleteMatchAttribute|,
 * like |attributedFullText|.
 */
@property(nonatomic, copy, readonly) NSAttributedString *attributedPrimaryText;

/**
 * The secondary text of a prediction as a NSAttributedString, usually the location of the place.
 * E.g. "Sydney, New South Wales, Australia".
 *
 * Text ranges that match user input are have a |kGMSAutocompleteMatchAttribute|, like
 * |attributedFullText|.
 *
 * May be nil.
 */
@property(nonatomic, copy, readonly) NSAttributedString *GMS_NULLABLE_PTR attributedSecondaryText;

/**
 * An optional property representing the place ID of the prediction, suitable for use in a place
 * details request.
 */
@property(nonatomic, copy, readonly) NSString *GMS_NULLABLE_PTR placeID;

/**
 * The types of this autocomplete result.  Types are NSStrings, valid values are any types
 * documented at <https://developers.google.com/places/supported_types>.
 */
@property(nonatomic, copy, readonly) GMS_NSArrayOf(NSString *) *types;

@end

GMS_ASSUME_NONNULL_END
