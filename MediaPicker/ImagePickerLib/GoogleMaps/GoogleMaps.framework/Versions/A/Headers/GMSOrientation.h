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
//  GMSOrientation.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>

/**
 * GMSOrientation is a tuple of heading and pitch used to control the viewing direction of a
 * GMSPanoramaCamera.
 */
typedef struct {
  /** The camera heading (horizontal angle) in degrees. */
  const CLLocationDirection heading;

  /**
   * The camera pitch (vertical angle), in degrees from the horizon. The |pitch| range is [-90,90],
   * although it is possible that not the full range is supported.
   */
  const double pitch;
} GMSOrientation;

#ifdef __cplusplus
extern "C" {
#endif

/** Returns a GMSOrientation with the given |heading| and |pitch|. */
inline static GMSOrientation GMSOrientationMake(CLLocationDirection heading, double pitch) {
  GMSOrientation orientation = {heading, pitch};
  return orientation;
}

#ifdef __cplusplus
}
#endif
