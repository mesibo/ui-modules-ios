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
//  GMSServices.h
//  Google Maps SDK for iOS
//
//  Copyright 2012 Google Inc.
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

/** Service class for the Google Maps SDK for iOS. */
@interface GMSServices : NSObject

/**
 * Provides the shared instance of GMSServices for the Google Maps SDK for iOS,
 * creating it if necessary. Classes such as GMSMapView and GMSPanoramaView will
 * hold this instance to provide their connection to Google.
 *
 * This is an opaque object. If your application often creates and destroys view
 * or service classes provided by the Google Maps SDK for iOS, it may be useful
 * to hold onto this object directly, as otherwise your connection to Google
 * may be restarted on a regular basis. It also may be useful to take this
 * object in advance of the first map creation, to reduce initial map creation
 * performance cost.
 *
 * This method will throw an exception if provideAPIKey: has not been called.
 */
+ (id<NSObject>)sharedServices;

/**
 * Provides your API key to the Google Maps SDK for iOS.  This key is generated
 * for your application via the Google APIs Console, and is paired with your
 * application's bundle ID to identify it.  This must be called exactly once
 * by your application before any iOS Maps SDK object is initialized.
 *
 * @return YES if the APIKey was successfully provided
 */
+ (BOOL)provideAPIKey:(NSString *)APIKey;

/**
 * Returns the open source software license information for Google Maps SDK for
 * iOS. This information must be made available within your application.
 */
+ (NSString *)openSourceLicenseInfo;

/**
 * Returns the version for this release of the Google Maps SDK for iOS.
 */
+ (NSString *)SDKVersion;

@end

GMS_ASSUME_NONNULL_END
