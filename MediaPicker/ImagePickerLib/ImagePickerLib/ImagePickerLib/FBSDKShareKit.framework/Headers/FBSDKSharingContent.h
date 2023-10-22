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

// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCopying.h>

/*!
 @abstract A base interface for content to be shared.
 */
@protocol FBSDKSharingContent <FBSDKCopying, NSSecureCoding>

/*!
 @abstract URL for the content being shared.
 @discussion This URL will be checked for all link meta tags for linking in platform specific ways.  See documentation
 for App Links (https://developers.facebook.com/docs/applinks/)
 @return URL representation of the content link
 */
@property (nonatomic, copy) NSURL *contentURL;

/*!
 @abstract List of IDs for taggable people to tag with this content.
 @description See documentation for Taggable Friends
 (https://developers.facebook.com/docs/graph-api/reference/user/taggable_friends)
 @return Array of IDs for people to tag (NSString)
 */
@property (nonatomic, copy) NSArray *peopleIDs;

/*!
 @abstract The ID for a place to tag with this content.
 @return The ID for the place to tag
 */
@property (nonatomic, copy) NSString *placeID;

/*!
 @abstract A value to be added to the referrer URL when a person follows a link from this shared content on feed.
 @return The ref for the content.
 */
@property (nonatomic, copy) NSString *ref;

@end
