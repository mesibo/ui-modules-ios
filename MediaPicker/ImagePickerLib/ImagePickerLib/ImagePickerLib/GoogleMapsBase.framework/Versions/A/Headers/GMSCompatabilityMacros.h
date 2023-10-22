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
//  GMSCompatabilityMacros.h
//  Google Maps SDK for iOS
//
//  Copyright 2015 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <Foundation/Foundation.h>

#if !__has_feature(nullability) || !defined(NS_ASSUME_NONNULL_BEGIN) || \
    !defined(NS_ASSUME_NONNULL_END)
#define GMS_ASSUME_NONNULL_BEGIN
#define GMS_ASSUME_NONNULL_END
#define GMS_NULLABLE
#define GMS_NULLABLE_PTR
#define GMS_NULLABLE_INSTANCETYPE instancetype
#else
#define GMS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#define GMS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#define GMS_NULLABLE nullable
#define GMS_NULLABLE_PTR __nullable
#define GMS_NULLABLE_INSTANCETYPE nullable instancetype
#endif

#if __has_feature(objc_generics) && defined(__IPHONE_9_0) && \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#define GMS_DECLARE_GENERICS 1
#else
#define GMS_DECLARE_GENERICS 0
#endif

#if GMS_DECLARE_GENERICS
#define GMS_NSArrayOf(value) NSArray<value>
#define GMS_NSDictionaryOf(key, value) NSDictionary<key, value>
#define GMS_NSSetOf(value) NSSet<value>
#else
#define GMS_NSArrayOf(value) NSArray
#define GMS_NSDictionaryOf(key, value) NSDictionary
#define GMS_NSSetOf(value) NSSet
#endif
