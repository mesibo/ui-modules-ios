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
//  GMSURLTileLayer.h
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

@class NSURL;

GMS_ASSUME_NONNULL_BEGIN

/**
 * |GMSTileURLConstructor| is a block taking |x|, |y| and |zoom|
 * and returning an NSURL, or nil to indicate no tile for that location.
 */
typedef NSURL *GMS_NULLABLE_PTR (^GMSTileURLConstructor)(NSUInteger x, NSUInteger y,
                                                         NSUInteger zoom);

/**
 * GMSURLTileProvider fetches tiles based on the URLs returned from a
 * GMSTileURLConstructor. For example:
 * <pre>
 *   GMSTileURLConstructor constructor = ^(NSUInteger x, NSUInteger y, NSUInteger zoom) {
 *     NSString *URLStr =
 *         [NSString stringWithFormat:@"https://example.com/%d/%d/%d.png", x, y, zoom];
 *     return [NSURL URLWithString:URLStr];
 *   };
 *   GMSTileLayer *layer =
 *       [GMSURLTileLayer tileLayerWithURLConstructor:constructor];
 *   layer.userAgent = @"SDK user agent";
 *   layer.map = map;
 * </pre>
 *
 * GMSURLTileProvider may not be subclassed and should only be created via its
 * convenience constructor.
 */
@interface GMSURLTileLayer : GMSTileLayer

/** Convenience constructor. |constructor| must be non-nil. */
+ (instancetype)tileLayerWithURLConstructor:(GMSTileURLConstructor)constructor;

/**
 * Specify the user agent to describe your application. If this is nil (the
 * default), the default iOS user agent is used for HTTP requests.
 */
@property(nonatomic, copy) NSString *GMS_NULLABLE_PTR userAgent;

@end

GMS_ASSUME_NONNULL_END
