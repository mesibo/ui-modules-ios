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
//  GMSSyncTileLayer.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMaps/GMSTileLayer.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSSyncTileLayer is an abstract subclass of GMSTileLayer that provides a sync
 * interface to generate image tile data.
 */
@interface GMSSyncTileLayer : GMSTileLayer

/**
 * As per requestTileForX:y:zoom:receiver: on GMSTileLayer, but provides a
 * synchronous interface to return tiles. This method may block or otherwise
 * perform work, and is not called on the main thread.
 *
 * Calls to this method may also be made from multiple threads so
 * implementations must be threadsafe.
 */
- (UIImage *GMS_NULLABLE_PTR)tileForX:(NSUInteger)x y:(NSUInteger)y zoom:(NSUInteger)zoom;

@end

GMS_ASSUME_NONNULL_END
