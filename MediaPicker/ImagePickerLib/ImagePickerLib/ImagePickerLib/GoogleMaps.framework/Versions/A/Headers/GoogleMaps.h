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
//  GoogleMaps.h
//  Google Maps SDK for iOS
//
//  Copyright 2012 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GMSAddress.h>
#import <GoogleMaps/GMSCALayer.h>
#import <GoogleMaps/GMSCameraPosition.h>
#import <GoogleMaps/GMSCameraUpdate.h>
#import <GoogleMaps/GMSCircle.h>
#import <GoogleMaps/GMSCoordinateBounds+GoogleMaps.h>
#import <GoogleMaps/GMSDeprecationMacros.h>
#import <GoogleMaps/GMSGeocoder.h>
#import <GoogleMaps/GMSGeometryUtils.h>
#import <GoogleMaps/GMSGroundOverlay.h>
#import <GoogleMaps/GMSIndoorBuilding.h>
#import <GoogleMaps/GMSIndoorDisplay.h>
#import <GoogleMaps/GMSIndoorLevel.h>
#import <GoogleMaps/GMSMapLayer.h>
#import <GoogleMaps/GMSMapView+Animation.h>
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GMSMarker.h>
#import <GoogleMaps/GMSMarkerLayer.h>
#import <GoogleMaps/GMSMutablePath.h>
#import <GoogleMaps/GMSOrientation.h>
#import <GoogleMaps/GMSOverlay.h>
#import <GoogleMaps/GMSPanorama.h>
#import <GoogleMaps/GMSPanoramaCamera.h>
#import <GoogleMaps/GMSPanoramaCameraUpdate.h>
#import <GoogleMaps/GMSPanoramaLayer.h>
#import <GoogleMaps/GMSPanoramaLink.h>
#import <GoogleMaps/GMSPanoramaService.h>
#import <GoogleMaps/GMSPanoramaView.h>
#import <GoogleMaps/GMSPath.h>
#import <GoogleMaps/GMSPolygon.h>
#import <GoogleMaps/GMSPolyline.h>
#import <GoogleMaps/GMSProjection.h>
#import <GoogleMaps/GMSServices.h>
#import <GoogleMaps/GMSSyncTileLayer.h>
#import <GoogleMaps/GMSTileLayer.h>
#import <GoogleMaps/GMSUISettings.h>
#import <GoogleMaps/GMSURLTileLayer.h>
